function run_bitbox {

if [[ $OS == Mac ]] ; then
open /Applications/BitBox.app
elif [[ $OS == Linux ]] ; then
~/parmanode/bitbox/Bit*AppImage &
fi

}