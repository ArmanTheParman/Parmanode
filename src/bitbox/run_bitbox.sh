function run_bitbox {

if [[ $OS == Mac ]] ; then
open /Applications/BitBox.app
elif [[ $OS == Linux ]] ; then
$hp/bitbox/Bit*AppImage >/dev/null 2>&1 &
fi

}