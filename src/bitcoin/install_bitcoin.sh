function install_bitcoin {

if grep -q bitcoin-end $ic ; then announce "Bitcoin already installed" ; jump $enter_cont ; return 0 ; fi
if grep -q bitcoin-start $ic ; then announce "Bitcoin partially installed" ; jump $enter_cont ; uninstall_bitcoin ; return 0 ; fi

# if installing bitcoin inside a docker container, then using btcpayinstallsbitcoin="true"
# if installing bitcoin and btcpay together in docker (initiated by a bitcoin install), then using btcdockerchoice="yes"

#set compile to false, and make true later depending on choices
export bitcoin_compile="false"
########################################################################################
#Check download file, verify, and printouts, are correct when changing...
########################################################################################
export knotsversion=28.1 
export deisversion=28.1
export knotsdate=20250305 
export knotstag="v${knotsversion}.knots${knotsdate}"
export knotsmajor=28.x
export knotsextension="tar.gz"
export coreexternsion="tar.gz"
[[ $OS == "Mac" ]] && export knotsversion=28.1 && export knotsdate=20250305 && knotsmajor=28.x && knotsextension="zip" && coreexternsion="tar.gz"
########################################################################################

if [[ $version != "self" ]] ; then
    export version="28.1"
fi

if [[ $btcpay_combo == "true" ]] ; then
export btcdockerchoice="yes"
else
    if [[ $OS == Mac && $btcpayinstallsbitcoin != "true" ]] ; then choose_bitcoin_version_mac || return 1 ; fi #get btcdockerchoice=yes or no
fi

if [[ $btcdockerchoice == "yes" ]] ; then

    #make sure docker installed
    grep -q "docker-end" $HOME/.parmanode/installed.conf || { announce "Must install Docker first.
    " \
    "Use menu: Add --> Other --> Docker). Aborting." && return 1 ; }

    #start docker if it is not running 
    if ! docker ps >$dn 2>&1 ; then 
    announce "Please make sure Docker is running, then try again. Aborting."
    return 1
    fi

fi #end btcdockerchoice

#btcpayinstallsbitcoin=true if installing from btcpay Dockerfile

export install="bitcoin"
export install_bitcoin_variable="true" #don't use same name as function!

if [[ -e /.dockerenv && $btcpayinstallsbitcoin != "true" ]] ; then announce "Bitcoin can be installed inside a Docker container, but may not
    run as expected with default Parmanode settings - you'll have to tweak."
fi

if ! [[ $btcpayinstallsbitcoin == "true" || $btcdockerchoice == "yes" ]] ; then

announce "So you want to install Bitcoin - nice one. May I take to this opportunity 
    to direct you to an essay I wrote about why it's important to run a node? 
    You might want to save this link for later...$cyan


    https://armantheparman.com/6reasonsnode $orange
    "
jump $enter_cont
fi
set_terminal

#choose version
choose_bitcoin_version || return 1 #no_compile variable set for macs here.

debug "after choose_bitcoin_version"

unset importdrive

choose_and_prepare_drive "Bitcoin" || return 1 # the argument "Bitcoin" is added as this function is also
                                             # called by a fulcrum installation, and electrs.
                                             # drive=internal or drive=external exported and added to parmanode.conf
format_ext_drive "Bitcoin" || return 1 #drive variable (internal vs external exported before)

debug "after format_ext_drive"

#Just in case (redundant permission setting)

if [[ $version == "self" ]] ; then break ; fi

if [[ $OS == "Linux" && $drive == "external" ]] ; then
    sudo chown -R $USER /media/$USER/parmanode >$dn 2>&1 \
    || log "bitcoin" "unable to execute chown in install_bitcoin function" 
fi

prune_choice || return 1 
    # set $prune_value. Doing this now as it is related to 
    # the drive choice just made by the user. 
    # Use variable later for setting bitcoin.conf

make_bitcoin_directories || return 1
    # make bitcoin directories in appropriate locations
    # installed.conf entry gets made when parmanode/bitcoin directory gets made.
    # symlinks created (before Bitcoin installed)

#compile bitcoin if chosen
compile_bitcoin || return 1


# Download bitcoin software & verify
if [[ $bitcoin_compile == "false" ]] ; then
download_bitcoin || return 1
fi

#setup bitcoin.conf
make_bitcoin_conf || { sww & return 1 ; }
menu_bitcoin_tor || { sww & return 1 ; }
#make a script that service file will use
if [[ $OS == "Linux" && $btcpayinstallsbitcoin != "true" && $btcdockerchoice != "yes" ]] ; then
    make_mount_check_script 
fi

#make service file - this allows automatic start up after a reboot
if [[ $OS == "Linux" && $btcpayinstallsbitcoin != "true" ]] ; then 
    make_bitcoind_service_file
fi

if [[ $btcpayinstallsbitcoin != "true" ]] ; then
sudo chown -R $USER: $HOME/.bitcoin/ 
fi

if [[ $btcpayinstallsbitcoin != "true"  && $btcdockerchoice != "yes" ]] ; then
#setting password. Managing behaviour of called function with variable and arguments.
unset skip
if [[ $version == self ]] && grep -q "rpcuser=" $bc ; then skip="true" ; else skip="false" 
fi
case $skip in
"false")
export dontstartbitcoin="true" && set_rpc_authentication "s" "install" && unset dontstartbitcoin
;;
esac

please_wait && start_bitcoin
fi #end not btcpainstallsbitcoin

if [[ $btcpayinstallsbitcoin == "true" ]] || [[ $btcpay_combo == "true" ]] ; then
#end internal docker installation here
#end btcpay then bitcoin install here
unset btcpayinstallsbitcoin btcpay_combo
return 0
fi

if [[ $btcdockerchoice == "yes" ]] ; then
unset btcdockerchoice
install_btcpay_mac_child || return 1
store_BTC_container_IP
success "Bitcoin and BTCPay Server has been installed in a Docker Container."
#end bitcoin then btcpay install here
return 0
fi

set_terminal

if [[ $OS == "Linux" ]] ; then

    if ! which bitcoind >$dn ; then
        enter_continue "Something went wrong. Bitcoin did not install correctly."
        install_failure "Bitcoin"
        log "bitcoin" "no binaries. install failure."
        unset importdrive
        return 1 
    fi

    if [[ -e $hp/bitcoin_github ]] ; then echo -e "
########################################################################################
    Delete$cyan $hp/bitcoin_github$orange directory (it can get big), 
    you can save space.

             $green y$orange     or    $red no $orange

########################################################################################
"
    read choice ; case $choice in y) sudo rm -rf $hp/bitcoin_github ;; esac
    fi

set_terminal ; echo -e "
########################################################################################
   $cyan 
                                    SUCCESS !!!
$orange
    Bitcoin should have started syncing. Note, it should also continue to sync 
    after a reboot, or you can start Bitcoin from the Parmanode Bitcoin menu at
    any time.

    You can also access Bitcoin functions from the Parmanode menu.

$green
    TIP:

    Make sure you turn off power saving features, particularly features that put
    the drive to sleep; Power saving is usually on by default for laptops.
$orange

########################################################################################
" && installed_conf_add "bitcoin-end"

    #Just in case - what? again? Anyway, I'll leave it.
    sudo chown -R $USER:$USER $parmanode_drive>$dn 2>&1

    enter_continue
fi


if [[ $OS == "Mac" ]] ; then
set_terminal
echo -e "
########################################################################################
$cyan 
                                    SUCCESS !!!
$orange
    Bitcoin should have started syncing.

    Bitcoin can be started from the Parmanode-Bitcoin menu, or by clicking the Bitcoin
    App icon in the Applications folder.
    
    For now, there is no configuration to automatically make Bitcoin start after a 
    reboot, as it seemed to introduce too much potential for error. This feature is 
    only available on Linux.
$green
    Do remmember to manually restart Bitcoin should your Mac power off. 
$orange
########################################################################################
" && installed_conf_add "bitcoin-end" 
  
enter_continue
fi

unset importdrive install_bitcoin_variable raid enter_cont
set_terminal
return 0
}

function print_bitcoin_variables {
debug "
$1
checking variables:
drive, $drive 
prune_value, $prune_value
bitcoin_choice, $bitcoin_choice
UUID, $UUID
BTCIP, $BTCIP 
rpcuser, $rpcuser 
rpcpassword, $rpcpassword 
btc_authentication, $btc_authentication
format_choice, $format_choice 
skip_formatting, $skip_formatting 
justFormat, $justFormat
driveproblem, $driveproblem
"
}
