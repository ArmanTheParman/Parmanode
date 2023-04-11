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

########################################################################################

function apply_prune_bitcoin.conf {

#source prune value from parmanode.conf

source $HOME/.parmanode/parmanode.conf

#check if prune_value set. If not, calls function to set it. 
if [[ -z ${prune_value} ]] ; then echo "Prune choice not detected. Needs to be set." ; enter_continue ; prune_choice ; fi

#cannot have prune 0 with txindex and blockfilterindex.

if [[ $prune_value != "0" ]]
then
	delete_line "$HOME/.bitcoin/bitcoin.conf" "txindex=1"
	delete_line "$HOME/.bitcoin/bitcoin.conf" "blockfilterindex=1"
fi

if [[ $prune_value == "0" ]]
then
	#delete all first, in case of multiple occurrences.
	delete_line "$HOME/.bitcoin/bitcoin.conf" "txindex=1"
	delete_line "$HOME/.bitcoin/bitcoin.conf" "blockfilterindex=1"

	echo "txindex=1" >> $HOME/.bitcoin/bitcoin.conf
	echo "blockfilterindex=1" >> $HOME/.bitcoin/bitcoin.conf
fi

return 0
}
