function apply_prune_bitcoin_conf {
file="$db/bitcoin.conf"
if [[ $1 == umbrel ]] ; then export prune=0 ; file="$mount_point/.bitcoin/bitcoin.conf" ; fi

#source prune value from parmanode.conf

if [[ -z $prune ]] ; then
source $HOME/.parmanode/parmanode.conf >/dev/null 2>&1
fi

#check if prune_value set. If not, calls function to set it. 
if [[ -z ${prune_value} ]] ; then echo "Prune choice not detected. Needs to be set." ; enter_continue ; prune_choice ; fi

#cannot have prune 0 with txindex and blockfilterindex.

if [[ $prune_value != "0" ]] ; then
	delete_line "$file" "txindex=1"
	delete_line "$file" "blockfilterindex=1"
	delete_line "$file" "prune="
	echo "prune=$prune_value" | sudo tee -a $file >/dev/null  
fi

if [[ $prune_value == "0" ]] ; then
	#delete all first, in case of multiple occurrences.
	delete_line "$file" "txindex="
	delete_line "$file" "blockfilterindex="
	delete_line "$file" "prune="

	echo "txindex=1" | sudo tee -a $file >/dev/null
	echo "blockfilterindex=1" | sudo tee -a $file >/dev/null
fi

log "bitcoin" "end of apply_prune_bitcoin_conf function"
return 0
}
