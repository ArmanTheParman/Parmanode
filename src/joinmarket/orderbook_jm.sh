function orderbook_jm {
if [[ -z $obwatcherPID ]] ; then
pn_tmux "jmvenv 'activate' ;
$hp/joinmarket/scripts/obwatch/ob-watcher.py | tee $HOME/.joinmarket/orderbook.log ;
jmvenv 'deactivate' ; " "obw"
else 
kill $obwatcherPID 
fi
}