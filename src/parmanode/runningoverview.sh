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
ismempoolrunning
ispublicpoolrunning
iselectrumxrunning
isthunderhubrunning
}

function ispublicpoolrunning {
while true ; do

if ! docker ps >/dev/null 2>&1 ; then
export publicpoolrunning="false"
overview_conf_add "publicpoolrunning=false" "publicpoolrunning="
break
fi

if docker ps | grep -q 'public_pool' ; then
overview_conf_add "publicpoolrunning=true" "publicpoolrunning="
export publicpoolrunning="true" 
fi
break
done
}


function isbitcoinrunning {
unset bitcoinrunning

if grep -q "btccombo" < $ic ; then
    if docker exec btcpay ps | grep -q bitcoind ; then
        overview_conf_add "bitcoinrunning=true" "bitcoinrunning="
        export bitcoinrunning="true"
    else 
        overview_conf_add "bitcoinrunning=false" "bitcoinrunning="
        export bitcoinrunning="false"
    fi
return 0
fi

if [[ $OS == Mac ]] ; then #if docker container, then previous btccombo check takes care of it
    if pgrep Bitcoin-Q >/dev/null ; then 
    overview_conf_add "bitcoinrunning=true" "bitcoinrunning="
    export bitcoinrunning="true"
    else 
    overview_conf_add "bitcoinrunning=false" "bitcoinrunning="
    export bitcoinrunning="false"
    fi
    return 0
fi

if [[ $OS == Linux ]] ; then

    if ! ps -x | grep bitcoin | grep -q "bitcoin.conf" >/dev/null 2>&1 ; then 
    overview_conf_add "bitcoinrunning=false" "bitcoinrunning="
    export bitcoinrunning="false"
    return 0
    fi
   
    if [[ -e $HOME/.bitcoin/debug.log ]] ; then
        if tail -n 1 $HOME/.bitcoin/debug.log | grep -q  "Shutdown: done" ; then 
        overview_conf_add "bitcoinrunning=false" "bitcoinrunning="
        export bitcoinrunning="false"
        return 0
        fi
    else #no debug file, then bitcoin not running
        overview_conf_add "bitcoinrunning=false" "bitcoinrunning="
        export bitcoinrunning="false"
        return 0
    fi
    
    #finally
    if pgrep bitcoin >/dev/null 2>&1 ; then 
    overview_conf_add "bitcoinrunning=true" "bitcoinrunning="
    export bitcoinrunning="true"
    return 0
    fi

fi
}

function islndrunning {
unset lndrunning
if ps -x | grep lnd | grep bin >/dev/null 2>&1 || \
   ps -x | grep litd | grep bin >/dev/null 2>&1 || \
   docker exec lnd pgrep lnd >/dev/null 2>&1 ; then
export lndrunning="true"
overview_conf_add "lndrunning=true" "lndrunning="
else
export lndrunning="false"
overview_conf_add "lndrunning=false" "lndrunning="
fi

if ! grep -q "lnddocker" < $ic ; then 

    if lncli walletbalance >/dev/null 2>&1 ; then 
    export lndwallet=unlocked
    overview_conf_add "lndwallet=unlocked" "lndwallet="
    else
    export lndwallet=locked
    overview_conf_add "lndwallet=locked" "lndwallet="
    fi
else
    if docker exec lnd lncli walletbalance >/dev/null 2>&1 ; then 
    export lndwallet=unlocked
    overview_conf_add "lndwallet=unlocked" "lndwallet="
    else
    export lndwallet=locked
    overview_conf_add "lndwallet=locked" "lndwallet="
    fi
fi

}

function isfulcrumrunning {
if grep -q "fulcrum-" $ic ; then
    if ps -x | grep fulcrum | grep conf >/dev/null 2>&1 ; then 
    overview_conf_add "fulcrumrunning=true" "fulcrumrunning="
    else
    overview_conf_add "fulcrumrunning=false" "fulcrumrunning="
    fi 
fi 

if grep -q "fulcrumdkr-" $ic ; then
    if docker ps 2>/dev/null | grep -q fulcrum && docker exec -it fulcrum bash -c "pgrep Fulcrum" >/dev/null 2>&1 ; then
    overview_conf_add "fulcrumrunning=true" "fulcrumrunning="
    else
    overview_conf_add "fulcrumrunning=false" "fulcrumrunning="
    fi
fi
}

function iselectrsrunning {
if grep -q electrs- < $ic >/dev/null 2>&1 || grep -q electrs2 - <$ic >/dev/null 2>&1 ; then
    if ps -x | grep electrs | grep -q conf >/dev/null 2>&1 ; then 
    overview_conf_add "electrsrunning=true" "electrsrunning="
    else
    overview_conf_add "electrsrunning=false" "electrsrunning="
    fi
fi #end if grep

}
function iselectrsdkrrunning {
if ! docker ps 2>/dev/null | grep -q electrs ; then
overview_conf_add "electrsdkrrunning=false" "electrsdkrrunning="
return 1
fi
if docker exec -it electrs /home/parman/parmanode/electrs/target/release/electrs --version >/dev/null 2>&1 ; then
overview_conf_add "electrsdkrrunning=true" "electrsdkrrunning="
else
overview_conf_add "electrsdkrrunning=false" "electrsdkrrunning="
fi
}

function isbrerunning {

if [[ $computer_type == LinuxPC ]] ; then
    if sudo systemctl status btcrpcexplorer 2>&1 | grep -q "active (running)" >/dev/null 2>&1 ; then 
    overview_conf_add "brerunning=true" "brerunning="
    else
    overview_conf_add "brerunning=false" "brerunning="
    fi
fi

if [[ $OS == Mac || $computer_type == Pi ]] ; then
    if  docker ps 2>/dev/null | grep -q bre ; then 
        if docker exec -itu root bre /bin/bash -c 'ps -xa | grep "btc-rpc"' | grep -v grep >/dev/null 2>&1 ; then
        overview_conf_add "brerunning=true" "brerunning="
        else
        overview_conf_add "brerunning=false" "brerunning="
        fi
    else
    overview_conf_add "brerunning=false" "brerunning="
    fi
fi

}

function isbtcpayrunning {
if docker ps 2>/dev/null | grep -q btcp >/dev/null 2>&1 ; then 
overview_conf_add "btcpayrunning=true" "btcpayrunning="
else
overview_conf_add "btcpayrunning=false" "btcpayrunning="
fi
}

function isrtlrunning {

if docker ps 2>/dev/null | grep -q rtl ; then
overview_conf_add "rtlrunning=true" "rtlrunning="
else 
overview_conf_add "rtlrunning=false" "rtlrunning="
fi

function ismempoolrunning {
if docker ps 2>/dev/null | grep -q mempool_web ; then
overview_conf_add "mempoolrunning=true" "mempoolrunning="
else
overview_conf_add "mempoolrunning=false" "mempoolrunning="
fi
}

function iselectrumxrunning {
if pgrep electrumx >/dev/null 2>&1 ; then
overview_conf_add "electrumxrunning=true" "electrumxrunning="
else
overview_conf_add "electrumxrunning=false" "electrumxrunning="
fi

}

}
function isthunderhubrunning {
if docker ps 2>/dev/null | grep -q thunderhub ; then
overview_conf_add "thunderhubrunning=true" "thunderhubrunning="
else
overview_conf_add "thunderhubrunning=false" "thunderhubrunning="
fi

}
