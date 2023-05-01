function stop_bitcoind {

if [[ $OS == "Linux" ]] ; then 
set_terminal 
sudo systemctl stop bitcoind.service >/dev/null
continue 
fi

if [[ $OS == "Mac" ]] ; then
set_terminal 
/usr/local/bin/bitcoin-cli stop >/dev/null
continue
fi

return 0
}