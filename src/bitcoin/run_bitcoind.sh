function run_bitcoind {
if [[ $OS == "Linux" ]] ; then 
        set_terminal
        echo "Bitcoin will start in a moment..."
        mount_drive  
        set_terminal

        if grep -q "internal" $HOME/.parmanode/parmanode.conf >/dev/null 2>&1 # config file determines if bitcoin is running on an internal or external drive
        then    
                sudo systemctl start bitcoind.service 
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
        sudo systemctl start bitcoind.service 
        fi

echo "If there are not printed errors, Bitcoin has started." 
echo "You can see progress from the Parmanode Bitcoin log menu." ; enter_continue
fi                 


if [[ $OS == "Mac" ]] ; then
/usr/local/bin/bitcoind -datadir=$HOME/.bitcoin/ -conf=$HOME/.bitcoin/bitcoin.conf
if [[ $1 != "no_interruption" ]] ; then enter_continue ; fi
fi
return 0
}

function start_bitcoind {
run_bitcoind $1
}
