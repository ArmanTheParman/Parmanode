function patch_10 { debugf
udev_patch  #then change udev function too.
make_mount_check_script #fixed any glitches by remaking it
openssh_patch
sudo chmod 440 /etc/sudoers.d/parmanode_extend_sudo_timeout
echo "pUSER=$(whoami)" | tee -a $pc >$dn 2>&1
fix_torrc

parmanode_conf_remove "patch="
parmanode_conf_add "patch=10"
}

function make_restricted_bucket {

sudo mkdir -p /usr/local/parmanode
sudo chown root:root /usr/local/parmanode
sudo chmod 700 /usr/local/parmanode

#make script to move files into restricted location for sudoers to use
   # check existing files in $pn/restriced, except README
   # do signature verification, then copy bytes to new location (before releasing file descriptor).
   # add sudoers command to run said script

cat <<EOF | tee /usr/local/parmanode/
#!bin/bash

# These files must exist

test -f $pn/restricted/patch.sh || exit
test -f $pn/restricted/patch.sh.sig || exit



}