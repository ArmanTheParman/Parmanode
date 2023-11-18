function run_trezor {

if [[ $OS == Mac ]] ; then
open /Applications/"Trezor Suite.app"
fi

if [[ $OS == Linux ]] ; then
nohup ~/parmanode/trezor/Trezor*AppImage & >/dev/null
fi

}