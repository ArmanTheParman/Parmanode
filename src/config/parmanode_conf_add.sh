# install_parmanode adds drive choice here (drive=$hdd), and $prune_choice

function parmanode_conf_add {
add_it=$1
parmanode_conf_remove "$add_it"

echo "$add_it" | tee -a $HOME/.parmanode/parmanode.conf 
return 0
}



function parmanode_conf_remove {
program=$1

delete_line "$HOME/.parmanode/parmanode.conf" "$program"

return 0
}
