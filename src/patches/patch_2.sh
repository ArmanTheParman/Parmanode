function patch_2 {

sudo_check # needed for preparing drives etc.
gpg_check  # needed to download programs from github
curl_check # needed to download things using the command prompt rather than a browser.
which_computer_type
check_chip

parmanode_conf_remove "patch=1"
parmanode_conf_add "patch=2"

}