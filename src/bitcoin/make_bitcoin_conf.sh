function make_bitcoin_conf {
#Parmanode default config settings. Can be changed.
#Create a bitcoin.conf file in data directory.
#Overrides any existing file named bitcoin.conf
set_terminal``


if [[ -f $HOME/.bitcoin/bitcoin.conf ]]
	then 
	    set_terminal ; echo "The bitcoin.conf file already exists. Hit (o) to overwrite, or (a) to abort the installation."
		read choice
		while true ; do
			if [[ $choice == "a" ]] ; then return 1 ; fi
			if [[ $choice == "o" ]] ; then break ; fi
			echo ""
			invlalid
		done
	fi

echo "
server=1
txindex=1
blockfilterindex=1
daemon=1
rpcport=8332

rpcbind=127.0.0.1
rpcbind=172.17.0.2
rpcallowip=127.0.0.1
rpcallowip=172.17.0.0/16" > $HOME/.bitcoin/bitcoin.conf

apply_prune_bitcoin.conf

return 0
}
