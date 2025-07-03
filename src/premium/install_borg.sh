function install_borg {
# this installss borg v1.x ; the latest version, 2.x is not production ready yet.

clear
echo -e "$blue"
sudo apt-get update -y
sudo apt-get install borgbackup fuse3 -y || sww
}
