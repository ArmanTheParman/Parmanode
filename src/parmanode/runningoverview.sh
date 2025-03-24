function ispublicpoolrunning {
while true ; do

if ! podman ps >$dn 2>&1 ; then
export publicpoolrunning="false"
break
fi

if podman ps | grep -q 'public_pool' ; then
export publicpoolrunning="true" 
fi
break
done
}


function isbitcoinrunning {
unset bitcoinrunning

if grep -q "btccombo" $ic ; then
    if podman exec btcpay ps | grep -q bitcoind ; then
        export bitcoinrunning="true"
    else 
        export bitcoinrunning="false"
    fi
return 0
fi

if [[ $OS == Mac ]] ; then #if podman container, then previous btccombo check takes care of it
    if pgrep Bitcoin-Q >$dn ; then 
    export bitcoinrunning="true"
    else 
    export bitcoinrunning="false"
    fi
    return 0
fi

if [[ $OS == Linux ]] ; then

    if ! ps -x | grep bitcoin | grep -q "bitcoin.conf" >$dn 2>&1 ; then 
    export bitcoinrunning="false"
    return 0
    fi
   
    if [[ -e $HOME/.bitcoin/debug.log ]] ; then
        if tail -n 1 $HOME/.bitcoin/debug.log | grep -q  "Shutdown: done" ; then 
        export bitcoinrunning="false"
        return 0
        fi
    else #no debug file, then bitcoin not running
        export bitcoinrunning="false"
        return 0
    fi
    
    #finally
    if pgrep bitcoin >$dn 2>&1 ; then 
    export bitcoinrunning="true"
    return 0
    fi

fi
}

function islndrunning {
unset lndrunning
if ps -x | grep lnd | grep bin >$dn 2>&1 || \
   ps -x | grep litd | grep bin >$dn 2>&1 || \
   podman exec lnd pgrep lnd >$dn 2>&1 ; then
export lndrunning="true"
else
export lndrunning="false"
fi

if ! grep -q "lndpodman" $ic ; then 

    if lncli walletbalance >$dn 2>&1 ; then 
    export lndwallet=unlocked
    else
    export lndwallet=locked
    fi
else
    if podman exec lnd lncli walletbalance >$dn 2>&1 ; then 
    export lndwallet=unlocked
    else
    export lndwallet=locked
    fi
fi

}

function isfulcrumrunning {
if grep -q "fulcrum-" $ic ; then
    if ps -x | grep fulcrum | grep conf >$dn 2>&1 ; then 
    export fulcrumrunning="true"
    else
    export fulcrumrunning="false"
    fi 
fi 

if grep -q "fulcrumdkr-" $ic ; then
    if podman ps 2>$dn | grep -q fulcrum && podman exec -it fulcrum bash -c "pgrep Fulcrum" >$dn 2>&1 ; then
    export fulcrumrunning="true"
    else
    export fulcrumrunning="false"
    fi

fi
}

function iselectrsrunning {
if grep -q electrs- $ic >$dn 2>&1 || grep -q electrs2- $ic >$dn 2>&1 ; then
    if ps -x | grep electrs | grep -q conf >$dn 2>&1 ; then 
    export electrsrunning="true"
    else
    export electrsrunning="false"
    fi

    return 0
fi #end if grep

if grep -q electrsdkr $ic ; then
    if ! podman ps | grep -q electrs ; then
    export electrsrunning="false"
    return 1
    fi

    if podman exec -it electrs /home/parman/parmanode/electrs/target/release/electrs --version >$dn 2>&1 ; then
    export electrsrunning="true"
    else
    export electrsrunning="false"
    fi
return 0
fi
}

function isbrerunning {

if [[ $computer_type == LinuxPC ]] ; then
    if sudo systemctl status btcrpcexplorer 2>&1 | grep -q "active (running)" >$dn 2>&1 ; then 

    export brerunning="true" 
    else
    export brerunning="false" 
    fi
fi

if [[ $OS == Mac || $computer_type == Pi ]] ; then
    if  podman ps 2>$dn | grep -q bre ; then 
        if podman exec -itu root bre /bin/bash -c 'ps -xa | grep "btc-rpc"' | grep -v grep >$dn 2>&1 ; then
        export brerunning="true"
        else
        export brerunning="false"
        fi
    else
        export brerunning="false"
    fi
fi

}

function isbtcpayrunning {
if podman ps 2>$dn | grep -q btcp >$dn 2>&1 \
&& podman exec -it btcpay bash -c "ps aux | grep csproj | grep btcpay.log | grep -vq grep" \
&& podman exec -it btcpay bash -c "ps aux | grep csproj | grep NBX | grep -vq grep" ; then
export btcpayrunning="true"
else
export btcpayrunning="false"
fi
}

function isrtlrunning {

if podman ps 2>$dn | grep -q rtl ; then
export rtlrunning="true"
else 
export rtlrunning="false"
fi

function ismempoolrunning {
if podman ps 2>$dn | grep -q mempool_web \
&& podman ps 2>$dn | grep -q podman-api-1 \
&& podman ps 2>$dn | grep -q podman-db-1 ; then

export mempoolrunning="true"
else
export mempoolrunning="false"
fi
}



}
function isthunderhubrunning {
if podman ps 2>$dn | grep -q thunderhub ; then
export thunderhubrunning="true"
else
export thunderhubrunning="false"
fi

}
