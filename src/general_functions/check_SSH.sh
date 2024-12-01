function check_SSH {
if grep -q "X11" $ic ; then return 0 ; fi
if [[ -n $SSH_CONNECTION ]] ; then
yesorno "Can not run via SSH unless you're using X11 forwarding. 
    You need a monitor connected. Try anyway?" || return 1
fi
return 0
}