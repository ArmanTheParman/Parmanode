function install_nostrrelay {
export install=nostr
#docs
#https://www.purplerelay.com/how-to-run-a-nostr-relay-a-step-by-step-guide/
#https://usenostr.org/relay
#https://nostr.how/en/relays


#some shared code and shared directories with ParaWeb.
no_mac || { announce "If there is demand for Macs, it's up to you to let me know and I'll get on to it." ; return 1 ; }

if grep -q "website" < $ic >/dev/null 2>&1 ; then
announce "Parmanode does not support a Nostr Relay and a Website on the same computer.
    Please install on another computer, or completely uninstall the Parmanode Website
    first. Aborting."
return 1
fi

grep -q docker-end < $HOME/.parmanode/installed.conf || { announce "Must install Docker first.
" \
"Use menu: Add --> Other --> Docker). Aborting." && return 1 ; }

sned_sats
########################################################################################
#drive choices
########################################################################################
choose_and_prepare_drive "nostr" || return 1
source $pc >/dev/null

if [[ $drive_nostr == external ]] && grep "=external" < $pc | grep -vq "nostr" ; then #don't grep 'external' alone, too ambiguous
    # format not needed
    # Get user to connect drive.
      pls_connect_drive || return 1 

elif [[ $drive_nostr == external ]] ; then

      format_ext_drive "nostr" || return  1

elif [[ $drive_nostr == custom ]] ; then

      add_custom_drive || return 1
fi

restore_nostr_data_backup #info only

nostr_data_exists_or_create || return 1

########################################################################################
install_tor silent || return 1
nostr_tor_add || return 1
installed_conf_add "nostrrelay-start"

website_update_system # runs apt-get

if [[ -e /var/www/website ]] ; then
announce "
    The directory /var/www/website already exits. Please delete it or move it and
    try again. Aborting."
return 1
fi

website_check_ports || return 1 #if port 80 or 443 in use and not by nginx, then abort.
install_nginx
install_certbot

########################################################################################
cd $hp
git clone --depth 1 https://github.com/scsibug/nostr-rs-relay.git nostrrelay
cd nostrrelay 

#Bookworm version fails, need to revert back to bullseye
sudo gsed -i 's/bookworm/bullseye/g' Dockerfile >$dn 2>&1

#################################
# configure settings...
#################################
nostrrelay_edit_config || return 1
nostrrelay_reverse_proxy_info

#################################

nostr_website_directory

make_website_nginx nostr

check_ready_for_ssl && nostrrelay_ssl_on install

sudo systemctl restart nginx >/dev/null 2>&1

echo -e "${green}Building Docker image..."
nostrrelay_build
echo -e "Pause to check if build successful"
read
nostrrelay_run

installed_conf_add "nostrrelay-end"

unset IP_choice
success "Your Nostr Relay has been set up"
}
