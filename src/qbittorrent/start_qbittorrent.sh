function start_qbittorrent {

if [[ $OS == Mac ]] ; then
open /Applications/qbittorrent.app 
fi

if [[ $OS == Linux ]] ; then
nohup $hp/qbittorrent/qbittorrent*AppImage >/dev/null 2>&1 &
fi

if [[ $computer_type == Pi ]] ; then
announce "Not supported for your OS, sorry." && return 1
fi
set_terminal ; echo -e "
########################################################################################
$cyan
   qBittorrent$orange will open in a moment in it's own window. You can continue to use
   Parmanode as normal, or minimise it. 

########################################################################################
"
enter_continue

}