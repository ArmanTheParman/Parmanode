function stop_bitcoind {

if [[ $OS == "Linux" ]] ; then 
set_terminal 
please_wait
sudo systemctl stop bitcoind.service 
fi

if [[ $OS == "Mac" ]] ; then
set_terminal 
please_wait
/usr/local/bin/bitcoin-cli stop
if [[ $1 != "no_interruption" ]] ; then enter_continue ; fi
fi
return 0
}
