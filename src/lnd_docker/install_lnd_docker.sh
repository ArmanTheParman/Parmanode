function install_lnd_docker {
set_terminal
export install=lnddocker
export lndversion="v0.17.3-beta"

grep -q bitcoin-end < $HOME/.parmanode/installed.conf || { announce "Must install Bitcoin first. Aborting." && return 1 ; }
install_check "lnd" || { announce "LND seems to already be installed. Aborting" ; return 1 ; }
install_check "lnddocker" || { announce "LND seems to already be installed. Aborting" ; return 1 ; }
if docker ps | grep -q lnd ; then
announce "LND in Docker seems to be running. Aborting Installation."
return 1 
fi

please_wait

installed_config_add "lnddocker-start" 
make_lnd_directories || return 1


#apply variables first
modify_lnd_dockerfile || return 1
build_lnd_docker || return 1
lnd_docker_run || return 1
debug "after docker run and start"

#password file, even if blank, needs to exists for lnd conf file to be valid
if [[ $reusedotlnd != true ]] ; then
touch $HOME/.lnd/password.txt  
make_lnd_conf 
fi

lnd_docker_start || { announce "Couldn't start lnd, aborting." ; return 1 ; }
debug "check lnd started in container"

if [[ $reusedotlnd != true ]] ; then
create_wallet && lnd_wallet_unlock_password  # && because 2nd command necessary to create
                                             # password file and needs new wallet to do so.
#start git repository in .lnd directory to allow undo's
cd $HOME/.lnd && git init >/dev/null 2>&1
fi

installed_config_add "lnddocker-end"

success "LND Docker" "being installed"
unset install

if grep -q "rtl-end" < $dp/installed.conf ; then
while true ; do
set_terminal ; echo -e "
########################################################################################
    
    Parmanode has detected that RTL is installed. It's not going to properly
    connect to LND unless you uninstall and install again. This will allow
    Parmanode to set up the configuration properly, now that LND is new.
    
    Reinstall RTL now?    $cyan y    or    n$orange 

########################################################################################
" 
choose "xpmq" ; read choice
case $choice in

m|M) back2main ;;
q|Q) exit ;;
n|N|NO|No|no|p|P) return 0 ;;
y|Y|Yes|YES|yes)
uninstall_rtl
install_rtl
return 0
;;
*) invalid ;;
esac
done
fi
}