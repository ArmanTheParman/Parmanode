function install_lnd {
set_terminal

if [[ $debug != 1 ]] ; then
grep -q bitcoin-end < $HOME/.parmanode/installed.conf || { announce "Must install Bitcoin first. Aborting." && return 1 ; }
fi

please_wait

install_check "lnd" || return 1

make_lnd_directories && \
installed_config_add "lnd-start" 

download_lnd

verify_lnd || return 1
unpack_lnd

sudo install -m 0755 -o $(whoami) -g $(whoami) -t /usr/local/bin $HOME/parmanode/lnd/lnd-*/* >/dev/null 2>&1

set_lnd_alias

#password file, even if blank, needs to exists for lnd conf file to be valid
touch $HOME/.lnd/password.txt
make_lnd_conf


#do last. Also runs LND
make_lnd_service 

#Make sure LND has started.
start_LND_loop

create_wallet
lnd_wallet_unlock_password

installed_conf_add "lnd-end"
success "LND" "being installed."

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
choose "xpq" ; read choice
case $choice in
q|Q) quit ;;
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

