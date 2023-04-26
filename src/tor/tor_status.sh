function tor_status {

set_terminal ; echo "
########################################################################################

    To see if Tor is running, you can enter the following in a terminal window:

                        Linux: sudo systemctl status tor

                        Mac:   brew services info tor

########################################################################################
"
}

function tor_status_check {

if [[ $OS == "Linux" ]] ; then sudo systemctl status tor ; fi
if [[ $OS == "Mac" ]] ; then brew services info tor ; fi
return 0 
}

function tor_start {


if [[ $OS == "Linux" ]] ; then sudo systemctl start tor ; fi
if [[ $OS == "Mac" ]] ; then brew services start tor ; fi

return 0
}