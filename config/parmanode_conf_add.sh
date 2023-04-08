# install_parmanode adds drive choice here (drive=$hdd), and $prune_choice

# These are variables so don't need to delete earlier entries. When the file is sourced, variables will equal the last entry.
# For it to be "cleaner", I'll change this later and swap variables if they exist, instead of duplicating entries.




function parmanode_conf_add {
addit=$1
parmanode_conf_remove "$addit"

echo "$addit" | tee -a $HOME/.parmanode/parmanode.conf 
return 0
}



function parmanode_conf_remove {
program=$1

delete_line "$HOME/.parmanode/parmanode.conf" "$program"

return 0
}
