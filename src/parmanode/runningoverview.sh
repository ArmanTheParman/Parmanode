function runningoverview {
#The function is to be called with the & signal to run in the background
#It sequentially calls other functions in a loop until it finds a signal to stop 
rm $oc
touch $oc

isbitcoinrunning 
islndrunning 
isfulcrumrunning 
iselectrsrunning 
iselectrsdkrrunning 
isbrerunning 
isbtcpayrunning 
isrtlrunning 
}


function isbitcoinrunning {
unset bitcoinrunning
if [[ $OS == Mac ]] ; then
    if pgrep Bitcoin-Q >/dev/null ; then 
    overview_conf_add "bitcoinrunning=true"
    export bitcoinrunning=true
    else 
    overview_conf_add "bitcoinrunning=false"
    export bitcoinrunning=false
    fi
    return 0
fi

if [[ $OS == Linux ]] ; then

    if ! ps -x | grep bitcoind | grep -q "bitcoin.conf" >/dev/null 2>&1 ; then 
    overview_conf_add "bitcoinrunning=false"
    fi
   
#override...
    if tail -n 1 $HOME/.bitcoin/debug.log | grep -q  "Shutdown: done" ; then 
    delete_line "$oc" "bitcoinrunning="
    overview_conf_add "bitcoinrunning=false"
    fi
#override...
    if pgrep bitcoind >/dev/null 2>&1 ; then 
    delete_line "$oc" "bitcoinrunning="
    overview_conf_add "bitcoinrunning=true"
    fi

    return 0
fi
}

function islndrunning {
unset lndrunning
if ps -x | grep lnd | grep bin >/dev/null 2>&1 ; then
overview_conf_add "lndrunning=true"
else
overview_conf_add "lndrunning=false"
fi

if lncli walletbalance >/dev/null 2>&1 ; then 
overview_conf_add "lndwallet=locked"
else
overview_conf_add "lndwallet=unlocked"
fi
}

function isfulcrumrunning {
if [[ $OS == "Linux" ]] ; then
    if ps -x | grep fulcrum | grep conf >/dev/null 2>&1 ; then 
    overview_conf_add "fulcrumrunning=true"
    else
    overview_conf_add "fulcrumrunning=false"
    fi 
fi #end if Linux

if [[ $OS == "Mac" ]] ; then
    if docker ps 2>/dev/null | grep -q fulcrum && docker exec -it fulcrum bash -c "pgrep Fulcrum" >/dev/null 2>&1 ; then
    overview_conf_add "fulcrumrunning=true"
    else
    overview_conf_add "fulcrumrunning=false"
    fi
fi
}
function iselectrsrunning {
if grep -q electrs- < $ic >/dev/null 2>&1 ; then
    if ps -x | grep electrs | grep -q conf >/dev/null 2>&1 ; then 
    overview_conf_add "electrsrunning=true"
    else
    overview_conf_add "electrsrunning=false"
    fi
fi #end if grep

}
function iselectrsdkrrunning {
if ! docker ps 2>/dev/null | grep -q electrs ; then
overview_conf_add "electrsdkrrunning=false"
return 1
fi
if docker exec -it electrs /home/parman/parmanode/electrs/target/release/electrs --version >/dev/null 2>&1 ; then
overview_conf_add "electrsdkrrunning=true"
else
overview_conf_add "electrsdkrrunning=false"
fi
}

function isbrerunning {

if [[ $computer_type == LinuxPC ]] ; then
    if sudo systemctl status btcrpcexplorer 2>&1 | grep -q "active (running)" >/dev/null 2>&1 ; then 
    overview_conf_add "brerunning=true"
    else
    overview_conf_add "brerunning=false"
    fi
fi

if [[ $OS == Mac || $computer_type == Pi ]] ; then
    if  docker ps 2>/dev/null | grep -q bre ; then 
    overview_conf_add "brerunning=true"
    else
    overview_conf_add "brerunning=false"
    fi
fi

}

function isbtcpayrunning {
if docker ps 2>/dev/null | grep -q btcp >/dev/null 2>&1 ; then 
overview_conf_add "btcpayrunning=true"
else
overview_conf_add "btcpayrunning=false"
fi
}

function isrtlrunning {

if docker ps 2>/dev/null | grep -q rtl ; then
overview_conf_add "rtlrunning=true"
else 
overview_conf_add "rtlrunning=false"
fi

}

