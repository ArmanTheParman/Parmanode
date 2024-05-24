function install_nostrrelay {
#docs
#https://www.purplerelay.com/how-to-run-a-nostr-relay-a-step-by-step-guide/
#https://usenostr.org/relay
#https://nostr.how/en/relays

grep -q docker-end < $HOME/.parmanode/installed.conf || { announce "Must install Docker first.
" \
"Use menu: Add --> Other --> Docker). Aborting." && return 1 ; }

sned_sats

cd $hp
git clone https://github.com/scsibug/nostr-rs-relay.git nostrrelay \
&& installed_conf_add "nostrrelay-start"


#################################
# configure settings...
#################################
nostrrelay_edit_config
nostrrelay_reverse_proxy_info

#################################

nostrrelay_directory

echo -e "${green}Building Docker image..."
nostrrelay_build

nostrrelay_run

installed_conf_add "nostrrelay-end"

success "Your Nostr Relay has been set up"
}
