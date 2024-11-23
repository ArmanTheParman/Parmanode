function next_patch {
reduce_systemd_logs
}


function reduce_systemd_logs {
if [[ $OS == Linux ]] ; then
sudo journalctl --vacuum-size=500M >$dn 2>&1
sudo gsed -iE 's/^.*SystemMaxUse.*$/SystemMaxUse=500M/' /etc/systemd/journald.conf >$dn 2>&1
debug "pause rsl"
fi
}