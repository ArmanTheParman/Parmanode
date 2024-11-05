function run_electrum {


if [[ $computer_type == "LinuxPC" ]] ; then
nohup $HOME/parmanode/electrum/electrum*AppImage >/dev/null 2>&1 &
fi


if [[ $computer_type == "Pi" ]] ; then
nohup $HOME/parmanode/electrum/run_electrum >/dev/null 2>&1 &
fi

if [[ $OS == "Mac" && python_electrum != "true" ]] ; then
open /Applications/Electrum.app
else
nohup $HOME/parmanode/electrum/run_electrum >/dev/null 2>&1 &
fi

set_terminal ; echo -e "
########################################################################################
$cyan
   Electrum$orange will open in a moment in it's own window. You can continue to use
   Parmanode as normal, or minimise it. 

########################################################################################
"
enter_continue


}