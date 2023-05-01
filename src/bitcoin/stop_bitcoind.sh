function stop_bitcoind {

if [[ $OS == "Linux" ]] ; then 
set_terminal 
sudo systemctl stop bitcoind.service >/dev/null
fi

if [[ $OS == "Mac" ]] ; then
set_terminal 
/usr/local/bin/bitcoin-cli stop >/dev/null
fi

return 0
}