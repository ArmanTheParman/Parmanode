function nginx_stream {
# if [[ -z $1 ]] ; then announce "no 1st argument to stream. aborting" ; return 1 ; fi

if ! sudo which nginx >$dn 2>&1 ; then return 0 ; fi

service="$1" #expecting electrs or public_pool
instruction="$2" #expecting install or remove

streamfile=$macprefix/etc/nginx/stream.conf

if [[ $2 != remove ]] ; then
sudo nginx -t >$dn 2>&1 || faulty_nginx_conf="true"
fi
#create a back up in case it breaks
[[ -e $nginxconf ]] && sudo cp $nginxconf ${nginxconf}_backup >$dn 2>&1

#test what is installed... 
#This search string will include installs that have begun and v1 and v2 of electrs/dkr)
source $pp/parmanode/src/nginx/stream.conf >$dn 2>&1
#unset what is not installed
if [[ $1 != electrs ]] ; then
   if ! grep -q "electrs-end" $ic && ! grep -q "electrsdkr" $ic ; then
   unset upstream_electrs server_electrs
   fi
fi
if [[ $1 != public_pool ]] ; then
if ! grep -q "public_pool-end" $ic ; then
unset upstream_public_pool server_public_pool
fi
fi

#unset what is to be deleted
if [[ $instruction == remove ]] ; then
unset upstream_$service server_$service
fi

#make a backup of the streamfile first
if [[ -e $streamfile ]] ; then
[[ -e $streamfile ]] && sudo cp $streamfile ${streamfile}_backup >$dn 2>&1
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
}" | sudo tee $streamfile >$dn 2>&1 
######################################################################################## Very ipmortant
``
#if no services installed, remove any include directive from nginx.conf
if [[ -z $upstream_electrs && -z $upstream_public_pool ]] ; then
    sudo test -e $ngxinxconf && sudo gsed -i "/stream.conf/d" $nginxconf 
else
#include stream file in nginx.conf
#this is added at the end of the file, not in any particular block
   sudo test -e $nginxconf && { if ! sudo grep -q "include stream.conf;" $nginxconf ; then 
   echo "include stream.conf;" | sudo tee -a $nginxconf
   fi
   }
fi
########################################################################################
#check nginx still runs (only if it was fine to begin with), if not revert to backup
if [[ ! $faulty_nginx_conf == "true" ]] ; then

    sudo nginx -t || {
    announce "\nSomething went wrong with the nginx conf setup. The file
    has been restored to the original. The erroneous file will be saved to $cyan
    $tmp/nginx.conf_error after you hit <enter>.$orange Please report error to Parman.

    Continuing, but Nginx configuration not optimal.
    " 
    sudo test -e $ngxinconf && {
    sudo cp ${nginxconf} $tmp/nginx.conf_error 
    sudo mv ${nginxconf}_backup $nginxconf >$dn 2>&1 ; }
    sudo test -e $streamfile && {
    sudo mv ${streamfile}_backup $streamfile >$dn 2>&1 ; }
    }
fi

}
# now redundant...
# function remove_old_electrs_stream_from_nginxconf {
# if [[ -e $nginx_conf && $OS == Linux ]] ; then sudo sed -i "/electrs-START/,/electrs-END/d" $nginx_conf >$dn ; fi
# if [[ -e $nginx_conf && $OS == Mac ]] ; then sudo sed -i '' "/electrs-START/,/electrs-END/d" $nginx_conf >$dn ; fi
# }