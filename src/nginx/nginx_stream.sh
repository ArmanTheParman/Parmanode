function nginx_stream {
# if [[ -z $1 ]] ; then announce "no 1st argument to stream. aborting" ; return 1 ; fi

service="$1" #expecting electrs or electrumx
instruction=$"2" #expecting install or remove


if [[ $OS == Mac ]] ; then
nginx_conf="/usr/local/etc/nginx/nginx.conf"
#ssl_cert="$hp/$service/cert.pem" 
#ssk_key="$hp/$service/key.pem"
streamfile="/usr/local/etc/nginx/stream.conf"

elif [[ $OS == Linux ]] ; then
nginx_conf="/etc/nginx/nginx.conf"
#ssl_cert="$hp/$service/cert.pem" 
#ssk_key="$hp/$service/key.pem"
streamfile="/etc/nginx/stream.conf"
fi

sudo nginx -t >/dev/null 2>&1 || \
 while true ; do 
echo -e "
########################################################################################
   Something is wrong with the nginx configuration file(s). 
   Before making any changes, Parmanode tested the configuration with the command $cyan
       sudo nginx -t $orange
   ... and the test failed. This means that Nginx won't run as the file stands before
   any changes are made.

   What would you like to do?...
$red
                            c)    Continue  (Proceed with caution)
$green
                            a)    Abort
$orange
########################################################################################
"
choose "xpmq" ; read choice 
case $choice in q|Q) exit 0 ;; p|P) return 1 ;; a|A|m|M) back2main ;;
c) 
faulty_nginx_conf=true
break ;;
*) invalid ;;
esac
done

#create a back up in case it breaks
sudo cp $nginx_conf ${nginx_conf}_backup >/dev/null 2>&1

#test what is installed... 
#This search string will include installs that have begun and v1 and v2 of electrs/dkr)
source $pp/parmanode/src/nginx/stream.conf >/dev/null 2>&1

#unset what is not installed
if ! grep -q "electrs" < $ic && ! grep -q "electrsdkr" ; then
unset upstream_electrs server_electrs
fi
if ! grep -q "electrumx" < $ic ; then
unset upstream_electrumx server_electrumx
fi

#unset what is to be deleted
if [[ $instruction == remove ]] ; then
unset upstream_$service server_$service
fi

debug "Variables from stream.conf...
1 - upstream electrs
$upstream_electrs
2 - upstream electrumx
$upstream_electrumx
3 - server electrs
$server_electrs
4 - server electrumx
$server_electrumx"

#make a backup of the streamfile first
if [[ -e $streamfile ]] ; then
sudo cp $streamfile ${streamfile}_backup >/dev/null 2>&1
fi

#with variables finalised, write the file...
#the streamfile is created new each time depending on what is installed
echo -en "
# This file is managed by Parmanode.
# Please do not edit this yourself, bad things can happen.
# Parmanode changes this file dynamically depending on what is installd.

stream {
$upstream_electrs
$upstream_electrumx
$server_electrs
$server_electrumx
}" | sudo tee $streamfile >/dev/null 2>&1 

#will eventuall become redundant, to clean up old version configuration
remove_old_electrs_stream_from_nginxconf

#if no services installed, remove any include directive from nginx.conf
if [[ -z $upstream_electrs && -z $upstream_electrumx ]] ; then
   delete_line "$nginx_conf" "stream.conf"
else
#include stream file in nginx.conf
#this is added at the end of the file, not in any particular block
   if ! grep -q "include stream.conf;" < $nginx_conf ; then 
   echo "include stream.conf;" | sudo tee -a $nginx_conf
   fi
fi

#check nginx still runs (only if it was fine to begin with), if not revert to backup
if [[ ! $faulty_nginx_conf == true ]] ; then
sudo nginx -t || sudo mv ${nginx_conf}_backup $nginx_conf && \
{  announce "Something went wrong with the nginx conf setup. The file
   has been restored to the original. Aborting." && sudo rm $streamfile && \
   sudo mv ${nginx_conf}_backup $nginx_conf >/dev/null 2>&1 && \
   sudo mv ${streamfile}_backup $streamfile >/dev/null 2>&1
   return 1
}
fi

}

function remove_old_electrs_stream_from_nginxconf {
if [[ $OS == Linux ]] ; then sudo sed -i "/electrs-START/,/electrs-END/d" $nginx_conf >/dev/null ; fi
if [[ $OS == Mac ]] ; then sudo sed -i '' "/electrs-START/,/electrs-END/d" $nginx_conf >/dev/null ; fi
}