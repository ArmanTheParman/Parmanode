function run_trezor {

if [[ $OS == Mac ]] ; then
open /Applications/"Trezor Suite.app"
fi

if [[ $OS == Linux ]] ; then
nohup ~/parmanode/trezor/Trezor*AppImage >/dev/null 2>&1
fi
set_terminal ; echo -e "
########################################################################################
$cyan
   Trezor App$orange will open in a moment in it's own window. You can continue to use
   Parmanode as normal, or minimise it. 

########################################################################################
"
enter_continue

}