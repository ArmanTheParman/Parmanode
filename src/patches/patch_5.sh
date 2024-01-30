function patch_5 {
debug "patch 5"

#tidying up files left in the wrong place from previous version's installation
mv $hp/*arrow-1.* $hp/Sparrow >/dev/null 2>&1

if [[ -e $HOME/parman_programs/set_terminal ]] ; then
rm -rf $HOME/parman_programs/set_terminal
fi

if [[ -f $bc ]] ; then
delete_line $bc "rpcallowip=172.17"
echo "rpcallowip=172.0.0.0/8" | sudo tee -a $bc >/dev/null 2>&1
fi

parmanode_conf_remove "patch="
parmanode_conf_add "patch=5"
debug "patch 5 end"
}