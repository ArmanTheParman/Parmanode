function install_jq {
if [[ $OS == Linux ]] ; then
sudo apt-get upday -y
sudo apt-get install jq -y
elif [[ $OS == Mac ]] ; then
brew install jq
fi

}