function patch_2 {

rm -rf $dp/.backup_files
delete_line "$dp/installed.conf" "parmanode-"

sudo_check # needed for preparing drives etc.
gpg_check  # needed to download programs from github
curl_check # needed to download things using the command prompt rather than a browser.
which_os
which_computer_type
check_chip

parmanode_conf_remove "patch=1"
parmanode_conf_add "patch=2"

}