
function isbitcoinrunning {
unset running
if [[ $OS == Mac ]] ; then
    if pgrep Bitcoin-Q >/dev/null ; then 
    export running=true 
    else export running=false 
    fi
    return 0
fi

if [[ $OS == Linux ]] ; then
    if ! ps -x | grep bitcoind | grep -q "bitcoin.conf" >/dev/null 2>&1 ; then 
    export bitcoinrunning=false
    fi
#override...
    if tail -n 1 $HOME/.bitcoin/debug.log | grep -q  "Shutdown: done" ; then 
    export bitcoinrunning=false
    fi
#override...
    if pgrep bitcoind >/dev/null 2>&1 ; then 
    export bitcoinrunning=true
    fi

    return 0
fi
}

function islndrunning {
unset lndrunning
if ps -x | grep lnd | grep bin >/dev/null 2>&1 ; then echo -e ; then
export lndrunning=true
else
export lndrunning=false

if lncli walletbalance >/dev/null 2>&1 ; then 
export lndwallet=locked
else
export lndwallet=unlocked
fi
}

function isfulcrumrunning {
if [[ $OS == "Linux" ]] ; then
    if ps -x | grep fulcrum | grep conf >/dev/null 2>&1 ; then 
    export fulcrumrunning=true
    else
    export fulcrumrunning=false
    fi 
fi #end if Linux

if [[ $OS == "Mac" ]] ; then
    if docker ps 2>/dev/null | grep -q fulcrum && docker exec -it fulcrum bash -c "pgrep Fulcrum" >/dev/null 2>&1 ; then
    export fulcrumrunning=true
    else
    export fulcrumrunning=false
    fi
fi
}
function iselectrsrunning {
if grep -q electrs- < $ic >/dev/null 2>&1 ; then
    if ps -x | grep electrs | grep conf >/dev/null 2>&1 ; then 
    export electrsrunning=true
    else
    export electrsrunning=false
    fi
fi #end if grep
if grep -q electrsdkr < $ic >/dev/null 2>&1 ; then

}
function iselectrsdkrrunning {
if docker exec -it electrs /home/parman/parmanode/electrs/target/release/electrs --version ; then
export electrsdkrrunning=true
else
export electrsdkrrunning=false
fi
}

function isbrerunning {

if [[ $computer_type == LinuxPC ]] ; then
    if sudo systemctl status btcrpcexplorer 2>&1 | grep -q "active (running)" >/dev/null 2>&1 ; then 
    export brerunning=true
    else
    export brerunning=false
    fi
fi

if [[ $OS == Mac || $computer_type == Pi ]] ; then
    if  docker ps | grep -q bre ; then 
    export brerunning=true
    else
    export brerunning=false
    fi
fi

}

function isbtcpayrunning {
if docker ps | grep btcp >/dev/null 2>&1 ; then 
export btcpayrunning=true
else
export btcpayrunning=false
fi
}

function isrtlrunning {

if docker ps | grep -q rtl ; then
export rtlrunning=true
else 
export rtlrunning=false
fi

}

