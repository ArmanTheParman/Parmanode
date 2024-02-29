function nginx_stream {
# if [[ -z $1 ]] ; then announce "no 1st argument to stream. aborting" ; return 1 ; fi

if ! which nginx >/dev/null 2>&1 ; then return 0 ; fi

service="$1" #expecting electrs or public_pool
instruction=$"2" #expecting install or remove


if [[ $OS == Mac ]] ; then
nginx_conf="/usr/local/etc/nginx/nginx.conf"
#ssl_cert="$hp/$service/cert.pem" 
#ssl_key="$hp/$service/key.pem"
streamfile="/usr/local/etc/nginx/stream.conf"

elif [[ $OS == Linux ]] ; then
nginx_conf="/etc/nginx/nginx.conf"
#ssl_cert="$hp/$service/cert.pem" 
#ssl_key="$hp/$service/key.pem"
streamfile="/etc/nginx/stream.conf"
fi

#will eventuall become redundant, to clean up old version configuration
remove_old_electrs_stream_from_nginxconf

if [[ $1 != remove ]] ; then
sudo nginx -t >/dev/null 2>&1 || faulty_nginx_conf=true
fi

#create a back up in case it breaks
sudo cp $nginx_conf ${nginx_conf}_backup >/dev/null 2>&1

#test what is installed... 
#This search string will include installs that have begun and v1 and v2 of electrs/dkr)
source $pp/parmanode/src/nginx/stream.conf >/dev/null 2>&1

#unset what is not installed
if [[ $1 != electrs ]] ; then
if ! grep -q "electrs-end" < $ic && ! grep -q "electrs2-end" < $ic && ! grep -q "electrsdkr" ; then
unset upstream_electrs server_electrs
fi
fi

if [[ $1 != public_pool ]] ; then
if ! grep -q "public_pool-end" < $ic ; then
unset upstream_public_pool server_public_pool
fi
fi

#unset what is to be deleted
if [[ $instruction == remove ]] ; then
unset upstream_$service server_$service
fi

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
$server_electrs
$upstream_public_pool
$server_public_pool
}" | sudo tee $streamfile >/dev/null 2>&1 

######################################################################################## Very ipmortant
``
#if no services installed, remove any include directive from nginx.conf
if [[ -z $upstream_electrs && -z $upstream_public_pool ]] ; then
   delete_line "$nginx_conf" "stream.conf"
else
#include stream file in nginx.conf
#this is added at the end of the file, not in any particular block
   if ! grep -q "include stream.conf;" < $nginx_conf ; then 
   echo "include stream.conf;" | sudo tee -a $nginx_conf
   fi
fi
########################################################################################

#check nginx still runs (only if it was fine to begin with), if not revert to backup
if [[ ! $faulty_nginx_conf == true ]] ; then

    sudo nginx -t || {announce "Something went wrong with the nginx conf setup. The file
    has been restored to the original. The erroneous file will be saved to $cyan
    /tmp/nginx.conf_error after you hit <enter>.$orange Please report error to Parman.

    Continuing, but Nginx configuration not optimal.
    " ; sudo cp ${nginx_conf} /tmp/nginx.conf_error && \
    sudo mv ${nginx_conf}_backup $nginx_conf >/dev/null 2>&1 && \
    sudo mv ${streamfile}_backup $streamfile >/dev/null 2>&1 ; }

fi

}
function remove_old_electrs_stream_from_nginxconf {
if [[ -e $nginx_conf && $OS == Linux ]] ; then sudo sed -i "/electrs-START/,/electrs-END/d" $nginx_conf >/dev/null ; fi
if [[ -e $nginx_conf && $OS == Mac ]] ; then sudo sed -i '' "/electrs-START/,/electrs-END/d" $nginx_conf >/dev/null ; fi
}