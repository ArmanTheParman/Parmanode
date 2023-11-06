function install_fuse {
if [[ $1 != noupdate ]] ; then
sudo apt-get update -y
fi
sudo apt-get install fuse libfuse2 -y
}