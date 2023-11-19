function patch_3 {

if grep -q electrum-end < $dp/installed.conf || \
   grep -q sparrow-end  < $dp/installed.conf || \
   grep -q specter-end  < $dp/installed.conf || \
   grep -q bitbox-end   < $dp/installed.conf || \
   grep -q trezor-end   < $dp/installed.conf || \
   grep -q ledger-end   < $dp/installed.conf ; then

    if ! grep -q udev-end <$dp/installed.conf ; then
        installed_conf_add "udev-end"
    fi

#needed to fix a variable bug in lnd log trap
parmanode_conf_add "lndlogfirsttime=true"
parmanode_conf_remove "patch="
parmanode_conf_add "patch=3"
fi

}