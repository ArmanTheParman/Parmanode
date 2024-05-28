function install_lnd {
set_terminal
sned_sats

export lndversion="v0.17.3-beta"

bitcoin_choice_with_lnd

if [[ $bitcoin_choice_with_lnd == local ]] ; then
grep -q bitcoin-end < $HOME/.parmanode/installed.conf || { announce "Must install Bitcoin first. Aborting." && return 1 ; }
fi

please_wait

make_lnd_directories || return 1                ; debug "after make lnd dir"
installed_config_add "lnd-start" 

download_lnd

verify_lnd || return 1
echo -e "${green}Please wait, unzipping files...$orange"
unpack_lnd

sudo install -m 0755 -o $(whoami) -g $(whoami) -t /usr/local/bin $HOME/parmanode/lnd/lnd-*/* >/dev/null 2>&1
if [[ $reusedotlnd != "true" ]] ; then
set_lnd_port
if [[ ! -e $HOME/.lnd/password.txt ]] ; then sudo touch $HOME/.lnd/password.txt ; fi
make_lnd_conf
set_lnd_alias #needs to have lnd conf existing
fi


#do last. Also runs LND
make_lnd_service  

#Make sure LND has started.
start_LND_loop

if [[ $reusedotlnd != "true" ]] ; then
create_wallet && lnd_wallet_unlock_password  # && because 2nd command necessary to create
gsed -i '/^; wallet-unlock-password-file/s/^..//' $HOME/.lnd/lnd.conf
gsed -i '/^; wallet-unlock-allow-create/s/^..//' $HOME/.lnd/lnd.conf
# password file and needs new wallet to do so.
debug "after gsed"
#start git repository in .lnd directory to allow undo's
cd $HOME/.lnd && git init >/dev/null 2>&1
fi

store_LND_container_IP


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


function bitcoin_choice_with_lnd {
while true ; do
set_terminal ; echo -e "
########################################################################################

    You have a choice to use a local installation of Bitcoin (bitcoind) to use with 
    LND, or you can choose to connect to one not running on this particular machine.
$green
                local)$orange     Bitoind on local machine
$bright_blue
                remote)$orange    Bitcoind 

########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;;
local)
export bitcoin_location=local
break
;;
remote)
export bitcoin_location=remote
break
;;
*)
invalid
;;
esac
done
}