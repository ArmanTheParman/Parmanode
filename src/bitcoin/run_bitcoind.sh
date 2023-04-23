function run_bitcoind {
if [[ $OS == "Linux" ]] ; then 
         set_terminal ; echo "
########################################################################################
    
    Bitcoind should have been configured to restart automatically if your 
    computer restarts. However, the restart may fail, which sometimes happens if
    you have an external drive.

########################################################################################
"
        enter_continue
        mount_drive ; echo "Bitcoin will start in a moment..."
        set_terminal

        if grep -q "internal" $HOME/.parmanode/parmanode.conf >/dev/null 2>&1 # config file determines if bitcoin is running on an internal or external drive
        then    
                sudo systemctl start bitcoind.service &
                return 0
        fi



        if grep -q "external" $HOME/.parmanode/parmanode.conf >/dev/null 2>&1 #config file determines if bitcoin is running on an internal or external drive
        then
        echo "
########################################################################################

          Please connect the drive, otherwise bitcoind will have errors.

########################################################################################    
"
        enter_continue
        set_terminal
        sudo systemctl start bitcoind.service &
        fi

echo "If there are not printed errors, Bitcoin has started." ; enter_continue
continue
fi                 


if [[ $OS == "Mac" ]] ; then
/usr/local/bin/bitcoind -datadir=$HOME/.bitcoin/ -conf=$HOME/.bitcoin/bitcoin.conf
echo "Bitcoin has started." ; enter_continue 
continue

fi
return 0
}