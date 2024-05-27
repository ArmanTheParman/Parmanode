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

    # check if there is a backup nostr_data on the drive and restore it
      restore_nostr_drive #prepares drive based on existing backup and user choices
      debug "after restore_nostr_drive"
      if [[ $OS == Linux ]] ; then sudo chown -R $USER:$(id -gn) $original > /dev/null 2>&1 ; fi
                                                           # $original from function restore_nostr_drive
elif [[ $drive_nostr == external ]] ; then

      format_ext_drive "nostr" || return 
      #make directory nostr_data not needed because config file makes that hapen when nostrrelay run
      mkdir -p $parmanode_drive/nostr_data
      sudo chown -R $USER $parmanode_drive/nostr_data >/dev/null 2>&1

fi

prepare_drive_nostr || { log "electrs" "prepare_drive_electrs failed" ; return 1 ; } 

if [[ $drive_nostr == internal ]] ; then
restore_internal_nostr_data || return 1 
fi

########################################################################################
install_tor silent
nostr_tor_add
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
git clone https://github.com/scsibug/nostr-rs-relay.git nostrrelay


#################################
# configure settings...
#################################
nostrrelay_edit_config || return 1
nostrrelay_reverse_proxy_info
check_ready_for_ssl && nostrrelay_ssl_on install

#################################

nostrrelay_directories || return 1
nostr_website_directory

make_website_nginx nostr

sudo systemctl restart nginx >/dev/null 2>&1

echo -e "${green}Building Docker image..."
nostrrelay_build

nostrrelay_run

installed_conf_add "nostrrelay-end"

success "Your Nostr Relay has been set up"
}
