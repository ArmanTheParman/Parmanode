function apply_prune_bitcoin_conf {
nogsedtest
file="$db/bitcoin.conf"
if [[ $1 == umbrel ]] ; then export prune=0 ; file="$mount_point/.bitcoin/bitcoin.conf" ; fi

#source prune value from parmanode.conf

if [[ -z $prune ]] ; then
source $HOME/.parmanode/parmanode.conf >$dn 2>&1
fi


#check if prune_value set. If not, calls function to set it. 
if [[ -z ${prune_value} ]] ; then prune_choice ; fi

#cannot have prune 0 with txindex and blockfilterindex.

if [[ $prune_value == "0" || -z $prune_value ]] ; then
	#delete all first, in case of multiple occurrences.
	sudo gsed -i "/txindex=/d" $file
	sudo gsed -i "/blockfilterindex=/d" $file
	sudo gsed -i "/prune=/d" $file

	echo "txindex=1" | sudo tee -a $file >$dn
	echo "blockfilterindex=1" | sudo tee -a $file >$dn
	skipnext="true"
fi
if [[ $prune_value != "0" && $skipnext != "true" ]] ; then
    sudo gsed -i "/txindex=1/d" $file
	sudo gsed -i "/blockfilterindex=1/d" $file
	sudo gsed -i "/prune=/d" $file
	echo "prune=$prune_value" | sudo tee -a $file >$dn  
fi
debug "bitcoin - end of apply_prune_bitcoin_conf function"
return 0
}
