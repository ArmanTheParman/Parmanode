function patch_4 {
debug "patch 4"

if [[ -d $HOME/.lnd ]] ; then
cd $HOME/.lnd && git init >/dev/null 2>&1
cd - >/dev/null 2>&1
fi

parmanode_conf_remove "patch="
parmanode_conf_add "patch=4"
debug "patch 4 end"
}