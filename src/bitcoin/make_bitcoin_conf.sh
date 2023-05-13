function make_bitcoin_conf {
#Parmanode default config settings. Can be changed.
#Create a bitcoin.conf file in data directory.
#Overrides any existing file named bitcoin.conf
set_terminal


if [[ -f $HOME/.bitcoin/bitcoin.conf ]]
	then 

            while true ; do
	    set_terminal 
            echo "The bitcoin.conf file already exists. Hit (o) to overwrite, or (a) to abort the installation." && \
            log "bitcoin" "bitcoin.conf exists already"
	    read choice

			if [[ $choice == "a" ]] ; then return 1 ; fi
			if [[ $choice == "o" ]] ; then log "bitcoin" "conf overwrite" && break ; fi
			echo ""
			invalid
		done
	fi

{ echo "
server=1
txindex=1
blockfilterindex=1
daemon=1
rpcport=8332

zmqpubrawblock=tcp://127.0.0.1:28332
zmqpubrawtx=tcp://127.0.0.1:28333

whitelist=127.0.0.1
rpcbind=0.0.0.0
rpcallowip=10.0.0.0/8
rpcallowip=192.168.0.0/16
rpcallowip=172.17.0.0/16" > $HOME/.bitcoin/bitcoin.conf && log "bitcoin" "bitcoin conf made" ; } \
|| log "bitcoin" "bitcoin conf failed"


apply_prune_bitcoin_conf

return 0
}
