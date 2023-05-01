function stop_bitcoind {

if [[ $OS == "Linux" ]] ; then 
set_terminal 
sudo systemctl stop bitcoind.service >/dev/null 2>&1
fi

if [[ $OS == "Mac" ]] ; then
set_terminal 
/usr/local/bin/bitcoin-cli stop >/dev/null 2>&1
fi

return 0
}