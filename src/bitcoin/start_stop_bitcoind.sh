# I have used the name bitcoind, but later introduced bitcoin-qt for macs, the name of the function
# has been kept the same

function start_bitcoin { start_bitcoind ; }
function stop_bitcoin { stop_bitcoind ; }

function run_bitcoind {

#needs to be first...
if grep -q btccombo < $ic ; then

    if ! docker ps | grep -q btcpay ; then
        docker start btcpay >/dev/null 2>&1 ; sleep 3
    fi

    docker exec -d btcpay bitcoind

    return 0
fi

if [[ $OS == "Linux" ]] ; then 

                    if [[ $1 == "no_interruption" ]] ; then
                    sudo systemctl start bitcoind.service
                    return 0
                    fi


        set_terminal
        echo "Bitcoin will start in a moment..."
        if grep -q "drive=external" < $pc >$dn ; then mount_drive ; fi
        set_terminal
        sudo systemctl start bitcoind.service 
fi                 


if [[ $OS == "Mac" ]] ; then
        if grep -q "drive=external" < $pc >$dn ; then
                if ! mount | grep -q /Volumes/parmanode ; then
                announce "Bitcoin is setup to sync to the external drive, but it is not detected. Aborting."
                return 1
                fi
        else debug "else drive external
        pc is $pc"
        fi
run_bitcoinqt
fi
}

function start_bitcoind {
run_bitcoind $@
}

########################################################################################################################

function stop_bitcoind {

#needs to be first...
if grep -q btccombo < $ic ; then
docker exec btcpay bitcoin-cli stop 
return 0
fi

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
stop_bitcoinqt
fi
}

function start_bitcoin_indocker {
docker exec -itu parman btcpay bitcoind
}

function stop_bitcoin_docker {
docker exec -itu parman btcpay bitcoin-cli stop
}