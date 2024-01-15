function run_electrum {

please_wait

if [[ $computer_type == "LinuxPC" ]] ; then
nohup $HOME/parmanode/electrum/electrum*AppImage >/dev/null 2>&1 &
fi


if [[ $computer_type == "Pi" ]] ; then
nohup $HOME/parmanode/electrum/run_electrum >/dev/null 2>&1 &
fi

if [[ $OS == "Mac" ]] ; then
open /Applications/Electrum.app
fi

}

#FUNCTION HAS BEEN REPLACED AND IMPORVED
# function refresh_electrum_certs_cache_sockets {

# delete_line "$HOME/.electrum/config" "rpcpassword"
# cd $HOME/.electrum/
# rm -rf certs daemon* cache* >/dev/null 2>&1
# }