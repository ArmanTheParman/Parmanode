function install_vim {

if [[ $OS == Linux ]] ; then
sudo apt-get update -y && export APT_UPDATE="true"
sudo apt-get install vim -y
else
brew_check || return 1
brew install vim
fi
}