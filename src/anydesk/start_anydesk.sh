function start_anydesk {

    if [[ $OS == Mac ]] ; then
    open /Applications/AnyDesk.app
    fi
    if [[ $OS == Linux ]] ; then
    anydesk >/dev/null 2>&1 &
    fi
}