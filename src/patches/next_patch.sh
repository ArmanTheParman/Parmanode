function next_patch {

if [[ $OS == Linux ]] ; then
rm $hp/startup_scripts/rtl_startup.sh >$dn 2>&1
sudo systemctl stop rtl.service >$dn 2>&1
sudo systemctl disable rtl.service >$dn 2>&1
sudo rm /etc/systemd/system/rtl.service >$dn 2>&1
fi

reduce_systemd_logs

sudo systemctl enable ssh >$dn 2>&1
sudo systemctl start ssh >$dn 2>&1
}


function reduce_systemd_logs {
if [[ $OS == Linux ]] ; then
sudo journalctl --vacuum-size=500M >$dn 2>&1
sudo gsed -iE 's/^.*SystemMaxUse.*$/SystemMaxUse=500M/' /etc/systemd/journald.conf >$dn 2>&1
debug "pause rsl"
fi
}