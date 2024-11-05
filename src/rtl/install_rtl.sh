function install_rtl {
grep -q docker-end < $HOME/.parmanode/installed.conf || { announce "Must install Docker first.
" \
"Use menu: Add --> Other --> Docker). Aborting." && return 1 ; }

sned_sats

#start docker if it is not running 
if ! docker ps >/dev/null 2>&1 ; then 
announce "Please make sure Docker is running, then try again. Aborting."
return 1
fi

set_terminal
if [[ $debug != 1 ]] ; then
{ lncli wallet accounts list >/dev/null 2>&1 || \
docker exec lnd lncli wallet accounts list >/dev/null 2>&1 ; } || { echo -e "
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

docker build -t rtl $pn/src/rtl || { announce "failed to build RTL image" ; return 1 ; }

run_rtl_docker

mv $tmp/RTL-Config.json $HOME/parmanode/rtl

rtl_password_changer

start_rtl || { announce "RTL failed to run" ; return 1 ; }

if [[ $OS != Mac ]] ; then
make_rtl_service_file 
fi

success "RTL" "being installed."
installed_config_add "rtl-end"

}
