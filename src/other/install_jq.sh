function install_jq {
if which jq >$dn ; then return 0 ; fi

if [[ $OS == Linux ]] ; then
sudo apt-get update -y
sudo apt-get install jq -y
elif [[ $OS == Mac ]] ; then
brew install jq
fi

}