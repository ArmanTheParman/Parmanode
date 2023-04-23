function stop_bitcoind {

if [[ $OS == "Linux" ]] ; then 
set_terminal ; echo "Please wait a moment for Bitcoin to stop."
sudo systemctl stop bitcoind.service
enter_continue
continue 
fi

if [[ $OS == "Mac" ]] ; then
set_terminal ; echo "Please wait a moment for Bitcoin to stop."
/usr/local/bin/bitcoin-cli stop
enter_continue
continue
fi

return 0
}