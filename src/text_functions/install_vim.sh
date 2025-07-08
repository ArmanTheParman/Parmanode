function install_vim {

if [[ $OS == Linux ]] ; then
apt_get_upate
sudo apt-get install vim -y
else
brew_check || return 1
brew install vim
fi
}