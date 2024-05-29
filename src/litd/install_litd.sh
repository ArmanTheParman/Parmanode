function install_litd {
install=litd
set_terminal
sned_sats

unset remote_user remote_pass ipcore

if grep -q "lnd-" < $ic ; then announce "cant have both LND and LITD"; return 1 ; fi

export litdversion="v0.12.5-alpha"

if ! which nginx >/dev/null 2>&1 ; then install_nginx 
sudo rm /etc/nginx/sites-available/*
sudo rm /etc/nginx/sites-enabled/*
sudo systemctl restart nginx >/dev/null 2>&1
fi

bitcoin_choice_with_litd || return 1
 if [[ $bitcoin_choice_with_litd == local ]] ; then
 grep -q bitcoin-end < $HOME/.parmanode/installed.conf || { announce "Must install Bitcoin first. Aborting." && return 1 ; }
 fi

please_wait

make_litd_directories || return 1     ;    installed_config_add "litd-start" 

#Make symlink .lnd to .lit
if [[ -e $HOME/.lnd ]] ; then
announce "Can't proceed if $HOME/.lnd exists due to reasons. Please move this directory and try again."
return 1
else
ln -s $HOME/.lit $HOME/.lnd >/dev/null 2>&1
ln -s $HOME/.lit/lit.conf $HOME/.lnd/lnd.conf >/dev/null 2>&1
fi


download_litd

verify_litd || return 1
echo -e "${green}Please wait, unzipping files...$orange"
unpack_litd

sudo install -m 0755 -o $(whoami) -g $(whoami) -t /usr/local/bin $hp/litd/lightning-*/* >/dev/null 2>&1

if [[ $reusedotlitd != "true" ]] ; then
set_lnd_port #use lnd not litd
if [[ ! -e $HOME/.lit/password.txt ]] ; then sudo touch $HOME/.lit/password.txt ; fi
make_lit_conf
set_litd_password || return 1
set_lnd_alias #needs to have lit conf existing, use lnd not lit function
fi


#do last. Also runs litd 
make_litd_service  

#Make sure litd has started.
start_litd_loop

#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
if [[ $reusedotlitd != "true" ]] ; then
create_wallet && lnd_wallet_unlock_password  # && because 2nd command necessary to create, lnd not litd

# gsed=sed alias normally works, but failing here.
if [[ $OS == Linux ]] ; then
sed -i '/^; lnd.wallet-unlock-password-file/s/^..//' $HOME/.lit/lit.conf
sed -i '/^; lnd.wallet-unlock-allow-create/s/^..//' $HOME/.lit/lit.conf
else
gsed -i '/^; lnd.wallet-unlock-password-file/s/^..//' $HOME/.lit/lit.conf
gsed -i '/^; lnd.wallet-unlock-allow-create/s/^..//' $HOME/.lit/lit.conf
fi

# password file and needs new wallet to do so.
#start git repository in .lit directory to allow undo's
cd $HOME/.lit && git init >/dev/null 2>&1
fi
#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

store_LND_container_IP #lnd not litd

if [[ $bitcoin_choice_with_litd == remote ]] ; then
parmanode_conf_add "bitcoin_choice_with_litd=remote"
fi

enable_tor_litterminal
make_nginx_litd

installed_conf_add "litd-end"
success "LITD" "being installed."

if grep -q "rtl-end" < $dp/installed.conf ; then
while true ; do
set_terminal ; echo -e "
########################################################################################
    
    Parmanode has detected that RTL is installed. It's not going to properly
    connect to litd unless you uninstall and install again. This will allow
    Parmanode to set up the configuration properly, now that litd is new.
    
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

