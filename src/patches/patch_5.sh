function patch_5 {
debug "patch 5"

mv $hp/*arrow-1.* $hp/Sparrow >/dev/null 2>&1

if [[ -e $HOME/parman_programs/set_terminal ]] ; then
rm -rf $HOME/parman_programs/set_terminal
fi

if [[ ! -e $hm ]] ; then touch $hm ; fi

parmanode_conf_remove "patch="
parmanode_conf_add "patch=5"
debug "patch 5 end"
}