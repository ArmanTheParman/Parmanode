function stop_bitcoinqt {
if [[ $OS == Mac ]] ; then

    if [[ $1 == force ]] ; then killall Bitcoin-Qt ; fi

    osascript -e 'tell application "Bitcoin-Qt" to quit' >$dn 2>&1
    please_wait
    # Wait until Bitcoin-Qt is no longer running
    while pgrep "Bitcoin-Qt" >$dn; do
    sleep 1
    done
else
    pkill -SIGTERM bitcoin-qt
fi


}
function run_bitcoinqt {
if [[ $OS == Mac ]] ; then
open /Applications/Bitcoin-Qt.app >$dn 2>&1
return 0
elif [[ $OS == Linux ]] ; then
    if pgrep bitcoin >$dn 2>&1 ; then return 1 ; fi
    nohup bitcoin-qt >$dn 2>&1 &
fi
}
