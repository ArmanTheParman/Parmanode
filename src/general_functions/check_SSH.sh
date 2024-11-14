function check_SSH {
if [[ -n $SSH_CONNECTION ]] ; then
yesorno "Can not run via SSH. You need a monitor connected. Try anyway?" || return 1
fi
return 0
}