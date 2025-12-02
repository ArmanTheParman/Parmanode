function patch_4 { debugf
# if [[ -d $HOME/.lnd ]] ; then
#     cd $HOME/.lnd && git init >$dn 2>&1
#     cd - >$dn 2>&1
# fi
parmanode_conf_remove "patch="
parmanode_conf_add "patch=4"
}

function patch_5 { debugf
parmanode_conf_remove "patch="
parmanode_conf_add "patch=5"
}

function patch_6 { debugf
parmanode_conf_remove "patch="
parmanode_conf_add "patch=6"
}
