function install_lnd {
set_terminal
sned_sats

unset remote_user remote_pass ipcore

export lndversion="v0.17.5-beta"

bitcoin_choice_with_lnd || return 1

if [[ $bitcoin_choice_with_lnd == local ]] ; then
grep -q bitcoin-end < $HOME/.parmanode/installed.conf || { announce "Must install Bitcoin first. Aborting." && return 1 ; }
fi

please_wait

make_lnd_directories || return 1 
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

#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
if [[ $reusedotlnd != "true" ]] ; then
create_wallet && lnd_wallet_unlock_password  # && because 2nd command necessary to create

# gsed=sed alias normally works, but failing here.
if [[ $OS == Linux ]] ; then
sed -i '/^; wallet-unlock-password-file/s/^..//' $HOME/.lnd/lnd.conf
sed -i '/^; wallet-unlock-allow-create/s/^..//' $HOME/.lnd/lnd.conf
else
gsed -i '/^; wallet-unlock-password-file/s/^..//' $HOME/.lnd/lnd.conf
gsed -i '/^; wallet-unlock-allow-create/s/^..//' $HOME/.lnd/lnd.conf
fi

# password file and needs new wallet to do so.
debug "after gsed"
#start git repository in .lnd directory to allow undo's
cd $HOME/.lnd && git init >/dev/null 2>&1
fi
#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

store_LND_container_IP

if [[ $bitcoin_choice_with_lnd == remote ]] ; then
parmanode_conf_add "bitcoin_choice_with_lnd=remote"
fi

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
                remote)$orange    Bitcoind on another machine

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
set_remote_bitcoin_ip || return 1
break
;;
*)
invalid
;;
esac
done
}

function set_remote_bitcoin_ip {

while true ; do

clear ; echo -e "
########################################################################################

    Please type in the$pink IP address$orange of the Bitcoin Core instance you want to use, then
    hit$cyan <enter> $orange

########################################################################################
"
read ipcore

while true ; do
clear ; echo -e "
########################################################################################    
   
    Next, enter the rpc username for the Bitcoin Core instance.
    
    This can be found in it's corresponding bitcoin.conf file. If it doesn't exist,
    then Bitcoin Core doesn't have a username set up. You can create one by adding it
    to the bitcoin.conf file:
$yellow
                rpcuser=some_username
                rpcpassword=somepassword
$orange
    Then save and restart Bitcoin.
   $green 
    Type in the username then <enter>
$orange
########################################################################################
"
choose xpmq ; read remote_user ; set_terminal
case $remote_user in 
q|Q) exit ;; P|p|a) return 1 ;; M|m) back2main ;;
"") 
invalid
;;
*)
break
;;
esac
done

clear
echo -e "
########################################################################################

   Now type in the rpcpassword (found in the corresponding bitcoin.conf file) then
   hit$cyan <enter> $orange

########################################################################################
"
read remote_pass


set_terminal ; echo -e "
########################################################################################

    These are your entries...


        IP address:   $ipcore

        rpcuser:      $remote_user

        rpcpassword:  $remote_pass
$green
$blinkon
    Please make sure the following lines are in the bitcoin.conf file of the remote
    Bitcoin installation, or you'll get errors: $blinkoff
$pink
                        zmqpubrawblock=tcp://*:28332
                        zmqpubrawtx=tcp://*:28333 
$orange
    Hit$green <enter>$orange to accept, or$red x-<enter>$orange to try again.

########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
"")
break
;;
*)
continue
;;
esac
done

}
