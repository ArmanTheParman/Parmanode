function run_bitbox {

if [[ $OS == Mac ]] ; then
open /Applications/BitBox.app
elif [[ $OS == Linux ]] ; then
~/parmanode/bitbox/Bit*AppImage >/dev/null 2>&1 &
fi
set_terminal ; echo -e "
########################################################################################
$cyan
   BitBox App$orange will open in a moment in it's own window. You can continue to use
   Parmanode as normal, or minimise it. 

########################################################################################
"
enter_continue

}