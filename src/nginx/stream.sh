function stream {
# if [[ -z $1 ]] ; then announce "no 1st argument to stream. aborting" ; return 1 ; fi

service="$1"


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
   Something is wrong with the nginx configuration file(s). Proceed with caution.
$red
                            c)    Continue 
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
source $pp/parmanode/src/nginx/stream.sh >/dev/null 2>&1
if ! grep -q "electrs" < $ic && ! grep -q "electrsdkr" ; then
unset upstream_electrs server_electrs
fi
if ! grep -q "electrumx" < $ic ; then
unset upstream_electrumx server_electrumx
    

#create the stream file
echo -en "
# This file is managed by Parmanode.
# Please do not edit this yourself, bad things can happen.
# Parmanode changes this file dynamically depending on what is installd.

stream {
$upstream_electrs
$upstream_electrumx
$server_electrs
$server_electrumx
}" | sudo tee -a $streamfile >/dev/null 2>&1

remove_old_electrs_stream_from_nginxconf

#include stream file in nginx.conf
if ! grep -q "include stream.conf;" < $nginx_conf ; then 
echo "include stream.conf;" | sudo tee -a $nginx_conf
fi

#check nginx still runs (only if it was fine to begin with), if not revert to backup
if [[ ! $faulty_nginx_conf == true ]] ; then
sudo nginx -t || sudo mv ${nginx_conf}_backup $nginx_conf && \
{  announce "Something went wrong with the nginx conf setup. The file
   has been restored to the original. Aborting." && sudo rm $streamfile && \
   sudo mv ${nginx_conf}_backup $nginx_conf >/dev/null 2>&1
   return 1
}
fi

}

function remove_old_electrs_stream_from_nginxconf {
if [[ $OS == Linux ]] ; then sudo sed -i "/electrs-START/,/electrs-END/d" $nginx_conf >/dev/null ; fi
if [[ $OS == Mac ]] ; then sudo sed -i '' "/electrs-START/,/electrs-END/d" $nginx_conf >/dev/null ; fi
}