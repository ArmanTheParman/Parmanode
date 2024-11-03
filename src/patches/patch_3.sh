function patch_3 {
debug "patch 3"

if grep -q electrum-end $ic || \
   grep -q sparrow-end  $ic || \
   grep -q specter-end  $ic || \
   grep -q bitbox-end   $ic || \
   grep -q trezor-end   $ic || \
   grep -q ledger-end   $ic ; then

    if ! grep -q "udev-end" $ic && [[ $OS == Linux ]] ; then
        installed_conf_add "udev-end"
    fi
fi

#needed to fix a variable bug in lnd log trap
parmanode_conf_remove "patch="
parmanode_conf_add "patch=3"
}