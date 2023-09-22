function check_SSH {
if [[ -n $SSH_CONNECTION ]] ; then
announce "Can not run via SSH. You need a monitor connected."
return 1
fi
return 0
}