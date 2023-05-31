function stop_bitcoind {

if [[ $OS == "Linux" ]] ; then 
set_terminal 
please_wait
sudo systemctl stop bitcoind.service 
enter_continue

fi

if [[ $OS == "Mac" ]] ; then
set_terminal 
please_wait
/usr/local/bin/bitcoin-cli stop
enter_continue
fi

return 0
}
