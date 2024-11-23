function next_patch {
reduce_systemd_logs


}


function reduce_systemd_logs {
if [[ $OS == Linux ]] ; then
sudo journalctl --vacuum-size=1G >$dn 2>&1
sudo gsed -iE 's/^.*SystemMaxUse.*$/SystemMaxUse=1G/' /etc/systemd/journald.conf >$dn 2>&1
debug "pause rsl"
fi
}