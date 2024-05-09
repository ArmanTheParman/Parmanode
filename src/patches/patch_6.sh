function patch_6 {
debug "patch 5"

if [[ -e /usr/local/bin/rp ]] ; then
delete_line "/usr/local/bin/rp" "run_parmanode" 
echo './run_parmanode.sh $@' | sudo tee -a /usr/local/bin/rp >/dev/null 2>&1
fi


parmanode_conf_remove "patch="
parmanode_conf_add "patch=6"
debug "patch 6 end"
}