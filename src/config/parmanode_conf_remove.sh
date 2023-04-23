function parmanode_conf_remove {
remove_it=$1

delete_line "$HOME/.parmanode/parmanode.conf" "$remove_it"

return 0
}