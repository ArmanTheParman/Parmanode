function isbitcoinrunning {
unset running
if [[ $OS == Mac ]] ; then
    if pgrep Bitcoin-Q >/dev/null ; then export running=true ; else export running=false ; fi
fi

if [[ $OS == Linux ]] ; then
    if ! ps -x | grep bitcoind | grep -q "bitcoin.conf" >/dev/null 2>&1 ; then export running=false ; fi
    if tail -n 1 $HOME/.bitcoin/debug.log | grep -q  "Shutdown: done" ; then export running=false ; fi 2>/dev/null
    if pgrep bitcoind >/dev/null 2>&1 ; then export running=true ; fi
fi
}