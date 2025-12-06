function patch_10 { debugf
udev_patch  #then change udev function too.
make_mount_check_script #fixed any glitches by remaking it
openssh_patch
sudo chmod 440 /etc/sudoers.d/parmanode_extend_sudo_timeout

fix_torrc

parmanode_conf_remove "patch="
parmanode_conf_add "patch=10"
}


function make_restricted_bucket {

if ! sudo test -d /usr/local/parmanode && sudo mkdir -p /usr/local/parmanode

#make script to move files into restricted location for sudoers to use
   # check existing files in $pn/restriced, except README
   # do signature verification, then copy bytes to new location (before releasing file descriptor).
   # add sudoers command to run said script

}