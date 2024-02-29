function install_jq {
if which jq >/dev/null ; then return 0 ; fi

if [[ $OS == Linux ]] ; then
sudo apt-get upday -y
sudo apt-get install jq -y
elif [[ $OS == Mac ]] ; then
brew install jq
fi

}