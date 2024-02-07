function start_anydesk {

    if [[ $OS == Mac ]] ; then
    open /Applications/AnyDesk.app
    fi
    if [[ $OS == Linux ]] ; then
    anydesk >/dev/null 2>&1 &
    fi
set_terminal ; echo -e "
########################################################################################
$cyan
   AnyDesk$orange will open in a moment in it's own window. You can continue to use
   Parmanode as normal, or minimise it. 

########################################################################################
"
enter_continue

}