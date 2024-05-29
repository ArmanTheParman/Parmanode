function install_lnd_docker {
set_terminal
export install=lnddocker
export lndversion="v0.17.3-beta"

grep -q bitcoin-end < $HOME/.parmanode/installed.conf || { announce "Must install Bitcoin first. Aborting." && return 1 ; }

please_wait

installed_config_add "lnddocker-start" 
parmanode_conf_add "lnd_port=9735"

make_lnd_directories || { debug "make_lnd_directories failed" ; return 1 ; }


#apply variables first
modify_lnd_dockerfile || { debug "modify_lnd_dockerfile failed" ; return 1 ; }
build_lnd_docker || { debug "build_lnd_docker failed" ; return 1 ; }
lnd_docker_run || { debug "lnd_docker_run failed" ; return 1 ; }

debug "after docker run and start"

docker exec -itu root lnd bash -c "echo \"ControlPort 9051\" | tee -a /etc/tor/torrc" >/dev/null 2>&1

#password file, even if blank, needs to exists for lnd conf file to be valid
if [[ $reusedotlnd != "true" ]] ; then
touch $HOME/.lnd/password.txt  
make_lnd_conf 
set_lnd_alias #needs to have lnd conf existing
fi

lnd_docker_start || { announce "Couldn't start lnd, aborting." ; return 1 ; }
debug "check lnd started in container"

if [[ $reusedotlnd != "true" ]] ; then
create_wallet && lnd_wallet_unlock_password  # && because 2nd command necessary to create
                                             # password file and needs new wallet to do so.
if [[ $OS == Mac ]] ; then                                             
gsed -i '/^; wallet-unlock-password-file/s/^..//' $HOME/.lnd/lnd.conf
gsed -i '/^; wallet-unlock-allow-create/s/^..//' $HOME/.lnd/lnd.conf
else
sed -i '/^; wallet-unlock-password-file/s/^..//' $HOME/.lnd/lnd.conf
sed -i '/^; wallet-unlock-allow-create/s/^..//' $HOME/.lnd/lnd.conf
fi
#start git repository in .lnd directory to allow undo's
cd $HOME/.lnd && git init >/dev/null 2>&1
fi

installed_config_add "lnddocker-end"

success "LND Docker" "being installed"
unset install reusedotlnd

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