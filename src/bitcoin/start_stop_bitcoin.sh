# I have used the name bitcoind, but later introduced bitcoin-qt for macs, the name of the function
# has been kept the same

function restart_bitcoin { stop_bitcoin ; start_bitcoin ; }

function start_bitcoin {
#for docker (no systemctl, use tmux)
if [[ -e /.dockerenv ]] ; then
please_wait
pn_tmux "bitcoind -conf=$HOME/.bitcoin/bitcoin.conf"1
sleep 0.5
return 0
fi


#needs to be first...
if grep -q btccombo $ic ; then

    pn_tmux "
    if ! docker ps | grep -q btcpay ; then
        docker start btcpay >$dn 2>&1 ; sleep 3
    fi

    docker exec -it btcpay bitcoind
    "

sleep 0.5
return 0
fi

if [[ $OS == "Linux" ]] ; then 
    if grep -q "drive=external" $pc ; then mount_drive ; fi 
    pn_tmux "sudo systemctl start bitcoind.service"
    sleep 0.5
    enter_continue "pause"
fi                 

if [[ $(uname) == Darwin ]] ; then
        if grep -q "drive=external" $pc >$dn ; then
                if ! mount | grep -q /Volumes/parmanode ; then
                announce "Drive needs to be mounted"
                return 1
                fi
        fi
        run_bitcoinqt
        sleep 0.5
        return 0
fi
}


########################################################################################################################

function stop_bitcoin {

#for docker (no systemctl, use tmux)
if [[ -e /.dockerenv ]] ; then
pn_tmux "pkill bitcoind" 
sleep 0.5
return 0
fi

#needs to be first...
if grep -q btccombo $ic ; then
pn_tmux "
docker exec -it btcpay pkill bitcoind
"
sleep 0.5
return 0
fi

if [[ $OS == "Linux" ]] ; then 
pn_tmux "
sudo systemctl stop bitcoind.service 
"
sleep 0.5
enter_continue "stopping bitcoind"
return 0
fi

if [[ $OS == "Mac" ]] ; then
stop_bitcoinqt
sleep 0.5
return 0
fi
}

function start_bitcoin_indocker {
pn_tmux "
docker exec -itu parman btcpay bitcoind
"
sleep 0.5
}

function stop_bitcoin_docker {
pn_tmux "
docker exec -itu parman btcpay bitcoin-cli stop
"
sleep 0.5
return 0
}

function stop_bitcoinqt {
if [[ $OS == Mac ]] ; then

    if [[ $1 == force ]] ; then pn_tmux "killall Bitcoin-Qt" ; fi

    pn_tmux "osascript -e 'tell application "Bitcoin-Qt" to quit'"
    while pgrep "Bitcoin-Qt" >$dn; do
    sleep 1
    done

elif [[ $OS == Linux ]] ; then
    pn_tmux "pkill -SIGTERM bitcoin-qt"
    while pgrep bitcoin-qt >$dn ; do
    sleep 0.5
    done
fi

}
function run_bitcoinqt {
if [[ $OS == Mac ]] ; then
open /Applications/Bitcoin-Qt.app >$dn 2>&1
sleep 0.5
return 0
elif [[ $OS == Linux ]] ; then
    if pgrep bitcoin >$dn 2>&1 ; then return 1 ; fi
    nohup bitcoin-qt >$dn 2>&1 &
    sleep 0.5
fi
}
