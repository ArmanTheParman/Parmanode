function patch_10 { debugf
udev_patch  #then change udev function too.
make_mount_check_script #fixed any glitches by remaking it. Also, dont' remove - this will be always present, and not dependent on bitcoin install script.
openssh_patch
sudo chmod 440 /etc/sudoers.d/parmanode_extend_sudo_timeout
if ! grep -q pUSER $pc ; then
    echo "pUSER=$(whoami)" | tee -a $pc >$dn 2>&1
fi
fix_torrc
sudoers_patch
make_restricted_bucket
parmanode_conf_remove "patch="
parmanode_conf_add "patch=10"
}
