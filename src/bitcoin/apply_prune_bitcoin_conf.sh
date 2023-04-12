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
