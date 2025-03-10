function runningoverview {
#The function is to be called with the & signal to run in the background
#It sequentially calls other functions in a loop until it finds a signal to stop 
rm $oc
touch $oc

isbitcoinrunning 
islndrunning 
isfulcrumrunning 
iselectrsrunning 
isbrerunning 
isbtcpayrunning 
isrtlrunning 
ismempoolrunning
ispublicpoolrunning
iselectrumxrunning
isthunderhubrunning
debug end-running-overview
}

function ispublicpoolrunning {
while true ; do

if ! docker ps >$dn 2>&1 ; then
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

if grep -q "btccombo" $ic ; then
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
    if pgrep Bitcoin-Q >$dn ; then 
    overview_conf_add "bitcoinrunning=true" "bitcoinrunning="
    export bitcoinrunning="true"
    else 
    overview_conf_add "bitcoinrunning=false" "bitcoinrunning="
    export bitcoinrunning="false"
    fi
    return 0
fi

if [[ $OS == Linux ]] ; then

    if ! ps -x | grep bitcoin | grep -q "bitcoin.conf" >$dn 2>&1 ; then 
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
    if pgrep bitcoin >$dn 2>&1 ; then 
    overview_conf_add "bitcoinrunning=true" "bitcoinrunning="
    export bitcoinrunning="true"
    return 0
    fi

fi
}

function islndrunning {
unset lndrunning
if ps -x | grep lnd | grep bin >$dn 2>&1 || \
   ps -x | grep litd | grep bin >$dn 2>&1 || \
   docker exec lnd pgrep lnd >$dn 2>&1 ; then
export lndrunning="true"
overview_conf_add "lndrunning=true" "lndrunning="
else
export lndrunning="false"
overview_conf_add "lndrunning=false" "lndrunning="
fi

if ! grep -q "lnddocker" $ic ; then 

    if lncli walletbalance >$dn 2>&1 ; then 
    export lndwallet=unlocked
    overview_conf_add "lndwallet=unlocked" "lndwallet="
    else
    export lndwallet=locked
    overview_conf_add "lndwallet=locked" "lndwallet="
    fi
else
    if docker exec lnd lncli walletbalance >$dn 2>&1 ; then 
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
    if ps -x | grep fulcrum | grep conf >$dn 2>&1 ; then 
    export fulcrumrunning="true"
    overview_conf_add "fulcrumrunning=true" "fulcrumrunning="
    else
    export fulcrumrunning="false"
    overview_conf_add "fulcrumrunning=false" "fulcrumrunning="
    fi 
fi 

if grep -q "fulcrumdkr-" $ic ; then
    if docker ps 2>$dn | grep -q fulcrum && docker exec -it fulcrum bash -c "pgrep Fulcrum" >$dn 2>&1 ; then
    export fulcrumrunning="true"
    overview_conf_add "fulcrumrunning=true" "fulcrumrunning="
    else
    export fulcrumrunning="false"
    overview_conf_add "fulcrumrunning=false" "fulcrumrunning="
    fi

fi
}

function iselectrsrunning {
if grep -q electrs- $ic >$dn 2>&1 || grep -q electrs2- $ic >$dn 2>&1 ; then
    if ps -x | grep electrs | grep -q conf >$dn 2>&1 ; then 
    export electrsrunning="true"
    overview_conf_add "electrsrunning=true" "electrsrunning="
    else
    export electrsrunning="false"
    overview_conf_add "electrsrunning=false" "electrsrunning="
    fi

    return 0
fi #end if grep

if grep -q electrsdkr $ic ; then
    if ! docker ps | grep -q electrs ; then
    export electrsrunning="false"
    overview_conf_add "electrsrunning=false" "electrsrunning="
    return 1
    fi

    if docker exec -it electrs /home/parman/parmanode/electrs/target/release/electrs --version >$dn 2>&1 ; then
    export electrsrunning="true"
    overview_conf_add "electrsrunning=true" "electrsrunning="
    else
    export electrsrunning="false"
    overview_conf_add "electrsrunning=false" "electrsrunning="
    fi
return 0
fi
}

function isbrerunning {

if [[ $computer_type == LinuxPC ]] ; then
    if sudo systemctl status btcrpcexplorer 2>&1 | grep -q "active (running)" >$dn 2>&1 ; then 

    export brerunning="true" 
    overview_conf_add "brerunning=true" "brerunning="
    else
    export brerunning="false" 
    overview_conf_add "brerunning=false" "brerunning="
    fi
fi

if [[ $OS == Mac || $computer_type == Pi ]] ; then
    if  docker ps 2>$dn | grep -q bre ; then 
        if docker exec -itu root bre /bin/bash -c 'ps -xa | grep "btc-rpc"' | grep -v grep >$dn 2>&1 ; then
        export brerunning="true"
        overview_conf_add "brerunning=true" "brerunning="
        else
        export brerunning="false"
        overview_conf_add "brerunning=false" "brerunning="
        fi
    else
        export brerunning="false"
        overview_conf_add "brerunning=false" "brerunning="
    fi
fi

}

function isbtcpayrunning {
if docker ps 2>$dn | grep -q btcp >$dn 2>&1 \
&& docker exec -it btcpay bash -c "ps aux | grep csproj | grep btcpay.log | grep -vq grep" \
&& docker exec -it btcpay bash -c "ps aux | grep csproj | grep NBX | grep -vq grep" ; then
export btcpayrunning="true"
overview_conf_add "btcpayrunning=true" "btcpayrunning="
else
export btcpayrunning="false"
overview_conf_add "btcpayrunning=false" "btcpayrunning="
fi
}

function isrtlrunning {

if docker ps 2>$dn | grep -q rtl ; then
export rtlrunning="true"
overview_conf_add "rtlrunning=true" "rtlrunning="
else 
export rtlrunning="false"
overview_conf_add "rtlrunning=false" "rtlrunning="
fi

function ismempoolrunning {
if docker ps 2>$dn | grep -q mempool_web \
&& docker ps 2>$dn | grep -q docker-api-1 \
&& docker ps 2>$dn | grep -q docker-db-1 ; then

export mempoolrunning="true"
overview_conf_add "mempoolrunning=true" "mempoolrunning="
else
export mempoolrunning="false"
overview_conf_add "mempoolrunning=false" "mempoolrunning="
fi
}

function iselectrumxrunning {
if pgrep electrumx >$dn 2>&1 ; then
export electrumxrunning="true"
overview_conf_add "electrumxrunning=true" "electrumxrunning="
else
export electrumxrunning="false"
overview_conf_add "electrumxrunning=false" "electrumxrunning="
fi
}

}
function isthunderhubrunning {
if docker ps 2>$dn | grep -q thunderhub ; then
export thunderhubrunning="true"
overview_conf_add "thunderhubrunning=true" "thunderhubrunning="
else
export thunderhubrunning="false"
overview_conf_add "thunderhubrunning=false" "thunderhubrunning="
fi

}
