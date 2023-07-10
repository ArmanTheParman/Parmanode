function parmanode_conf_add {

if [[ ! -f $HOME/.parmanode/parmanode.conf ]] ; then
touch $HOME/.parmanode/parmanode.conf
fi

if [[ -z $1 ]] ; then return 0 ; fi

add_it=$1
parmanode_conf_remove "$add_it"

echo "$add_it" | tee -a $HOME/.parmanode/parmanode.conf 
return 0
}


function parmanode_conf_remove {
remove_it="$1"

delete_line "$HOME/.parmanode/parmanode.conf" "$remove_it"

return 0
}
