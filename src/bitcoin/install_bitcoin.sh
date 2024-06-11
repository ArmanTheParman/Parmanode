function install_bitcoin {
#dockerfile=true if installing from btcpay Dockerfile
export install=bitcoin
export install_bitcoin_variable="true" #don't use same name as function!

if [[ -e /.dockerenv && $dockerfile != "true" ]] ; then announce "Bitcoin can be installed inside a Docker container, 
    but it's not going to run with default Parmanode settings - you'll have
    to tweak."
fi

set_terminal

#choose version
choose_bitcoin_version || return 1 #no compile variable set for macs here.

unset importdrive

choose_and_prepare_drive "Bitcoin" || return 1 # the argument "Bitcoin" is added as this function is also
                                             # called by a fulcrum installation, and electrs.
                                             # drive=internal or drive=external exported and added to parmanode.conf
format_ext_drive "Bitcoin" || return 1 #drive variable (internal vs external exported before)

#Just in case (redundant permission setting)
    while true ; do 

        if [[ $version == self ]] ; then break ; fi

            if [[ $OS == "Linux" && $drive == "external" ]] ; then
                sudo chown -R $USER /media/$USER/parmanode >/dev/null 2>&1 \
                && log "bitcoin" "redundant chown applied in install_bitcoin function" \
                || log "bitcoin" "unable to execute chown in intstall_bitcoin function" 
            break
            fi
    break
    done

prune_choice || return 1 
    # set $prune_value. Doing this now as it is related to 
    # the drive choice just made by the user. 
    # Use variable later for setting bitcoin.conf
# The log call here helps determine if the function reached here in case troubleshooting later.
log "bitcoin" "make_bitcoin_directories function..."

make_bitcoin_directories || return 1
    # make bitcoin directories in appropriate locations
    # installed entry gets made when parmanode/bitcoin directory gets made.
    # symlinks created (before Bitcoin core installed)

#compile bitcoin if chosen
compile_bitcoin || return 1

# Download bitcoin software & verify
if [[ $bitcoin_compile == "false" ]] ; then
download_bitcoin || return 1
fi

#setup bitcoin.conf
    make_bitcoin_conf || return 1

#make a script that service file will use
if [[ $OS == "Linux" && $dockerfile != "true" ]] ; then
    make_mount_check_script 
fi

#make service file - this allows automatic start up after a reboot
if [[ $OS == "Linux" && $dockerfile != "true" ]] ; then 
    make_bitcoind_service_file
fi

if [[ $dockerfile != "true" ]] ; then
sudo chown -R $USER: $HOME/.bitcoin/ 
debug "b1"
else
sudo chown -R parman: $HOME/.bitcoin/
debug "b2"
fi
debug "b3"
if [[ $dockerfile != "true" ]] ; then
#setting password. Managing behaviour of called function with variable and arguments.
unset skip
debug "b4"
if [[ $version == self ]] && grep -q "rpcuser=" < $bc ; then skip="true" ; else skip="false" ; fi
case $skip in
"false")
export dontstartbitcoin="true" && set_rpc_authentication "s" "install" && unset dontstartbitcoin
;;
esac
debug "b5"
please_wait && run_bitcoind

else
success "Bitcoin installed in Docker Container with BTC Pay" 
return 0
fi #end no dockerfile

set_terminal

if [[ $OS == "Linux" ]] ; then

    if ! which bitcoind >/dev/null ; then
        install_failure "Bitcoin"
        log "bitcoin" "no binaries. install failure."
        debug "no binaries. install failure."
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
read choice ; case $choice in y) rm -rf $hp/bitcoin_github ;; esac
fi

set_terminal ; echo -e "
########################################################################################
   $cyan 
                                    SUCCESS !!!
$orange
    Bitcoin Core should have started syncing. Note, it should also continue to sync 
    after a reboot, or you can start Bitcoin Core from the Parmanode Bitcoin menu at
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
sudo chown -R $USER:$USER $parmanode_drive>/dev/null 2>&1

enter_continue
fi


if [[ $OS == "Mac" ]] ; then
set_terminal
echo -e "
########################################################################################
$cyan 
                                    SUCCESS !!!
$orange
    Bitcoin Core should have started syncing.

    Bitcoin can be started from the Parmanode-Bitcoin menu, or by clicking the Bitcoin
    App icon in the Applications folder.
    
    For now, thre is no configuration to automatically make Bitcoin Core 
    start after a reboot, as it seemed to introduce too much potential for error. 
    This feature is only available on Linux.
$green
    Do remmember to manually restart Bitcoin should your Mac power off. 
$orange
########################################################################################
" && installed_conf_add "bitcoin-end"
    #Just in case
            sudo chown -R $(whoami):staff /media/$(whoami)/parmanode >/dev/null 2>&1

enter_continue
fi

unset importdrive install_bitcoin_variable raid
set_terminal
}
