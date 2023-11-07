function install_rtl {
if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi
grep -q docker-end < $HOME/.parmanode/installed.conf || { announce "Must install Docker first.
" \
"Use menu: Add --> Other --> Docker). Aborting." && return 1 ; }

set_terminal
if [[ $debug != 1 ]] ; then
lncli wallet accounts list >/dev/null 2>&1 || { echo "
########################################################################################

    RTL is software that connects to your LND wallet. Parmanode helps by configuring
    the RTL software to point to the Parmanode LND wallet. It seems either LND is
    not running, you haven't made a LND wallet yet, or it is locked. A wallet is 
    required BEFORE installing RTL so that Parmanode can edit the configuration files 
    for you.

    Aborting installation. Please make a wallet and return to installing RTL.

########################################################################################
" && enter_continue && return 1 ; }
fi

mkdir $HOME/parmanode/rtl $HOME/parmanode/startup_scripts/ 2>/dev/null
installed_config_add "rtl-start"
make_rtl_config
docker build -t rtl ./src/rtl || { log "rtl" "failed to build rtl image" && return 1 ; }
docker run -d --name rtl \
                         --network="host" \
                         -v $HOME/parmanode/rtl:/home/parman/RTL2 \
		            	 -v $HOME/.lnd:/home/parman/.lnd \
                         -v $HOME/.parmanode/:/home/parman/.parmanode \
                         rtl \
        || { log "rtl" "failed to run rtl image" && return 1 ; }

mv /tmp/RTL-Config.json $HOME/parmanode/rtl

rtl_password_changer

start_rtl || { log "rtl" "rtl failed to run" && return 1 ; }

make_rtl_service_file && log "rtl" "rtl service file made"

success "RTL" "being installed."
installed_config_add "rtl-end"

}
