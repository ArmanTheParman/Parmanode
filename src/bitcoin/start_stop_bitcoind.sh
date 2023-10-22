# I have used the name bitcoind, but later introduced bitcoin-qt for macs, the name of the function
# has been kept the same

function run_bitcoind {
if [[ $OS == "Linux" ]] ; then 

                    if [[ $1 == "no_interruption" ]] ; then
                    sudo systemctl start bitcoind.service
                    return 0
                    fi


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
        sudo systemctl start bitcoind.service 
        fi
fi                 


if [[ $OS == "Mac" ]] ; then
open /Applications/Bitcoin-Qt.app
return 0
fi
}

function start_bitcoind {
run_bitcoind $@
}

########################################################################################################################

function stop_bitcoind {

if [[ $OS == "Linux" ]] ; then 
set_terminal 
please_wait
sudo systemctl stop bitcoind.service 2> /tmp/bitcoinoutput.tmp
if grep "28" < /tmp/bitcoinoutput.tmp ; then
echo "
    This might take longer than usual as Bitcoin is running a process 
    that shouldn't be interrupted. Please wait. 

    Trying every 5 seconds."
sleep 1 ; echo 1
sleep 1 ; echo 2
sleep 1 ; echo 3
sleep 1 ; echo 4
sleep 1 ; echo 5

stop_bitcoind
fi
fi

if [[ $OS == "Mac" ]] ; then

    if [[ $1 == force ]] ; then killall Bitcoin-Qt ; fi

    osascript -e 'tell application "Bitcoin-Qt" to quit' >/dev/null 2>&1
    please_wait
    # Wait until Bitcoin-Qt is no longer running
    while pgrep "Bitcoin-Q" > /dev/null; do
    sleep 1
    done
fi

}
