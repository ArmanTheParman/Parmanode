function run_trezor {

if [[ $OS == Mac ]] ; then
open /Applications/"Trezor Suite"
fi

if [[ $OS == Linux ]] ; then
~/parmanode/trezor/Trezor*AppImage
fi

}