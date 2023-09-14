function run_electrum {

please_wait
rm -rf $HOME/.electrum/certs daemon* cache* >/dev/null 2>&1

if [[ $OS == "Linux" ]] ; then
nohup $HOME/parmanode/electrum/electrum*AppImage >/dev/null 2>&1 &
fi

if [[ $OS == "Mac" ]] ; then
open /Applications/Electrum.app
fi

}