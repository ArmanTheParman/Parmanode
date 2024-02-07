function run_ledger {

if [[ $OS == Mac ]] ; then
open /Applications/"Ledger Live"*
fi

if [[ $OS == Linux ]] ; then
$HOME/parman_programs/ledger/*AppImage
fi
set_terminal ; echo -e "
########################################################################################
$cyan
   Ledger Live$orange will open in a moment in it's own window. You can continue to use
   Parmanode as normal, or minimise it. 

########################################################################################
"
enter_continue

}