function patch_10 { debugf
udev_patch  #then change udev function too.
make_mount_check_script #fixed any glitches by remaking it
openssh_patch
sudo chmod 440 /etc/sudoers.d/parmanode_extend_sudo_timeout
echo "pUSER=$(whoami)" | tee -a $pc >$dn 2>&1
fix_torrc

sudoers_patch
make_restricted_bucket
parmanode_conf_remove "patch="
parmanode_conf_add "patch=10"
}
