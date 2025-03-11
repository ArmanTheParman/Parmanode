function patch_8 {
nogsedtest
if [[ $OS == Linux ]] ; then

    rm $hp/startup_scripts/rtl_startup.sh >$dn 2>&1
    sudo systemctl stop rtl.service >$dn 2>&1
    sudo systemctl disable rtl.service >$dn 2>&1
    sudo rm /etc/systemd/system/rtl.service >$dn 2>&1

    reduce_systemd_logs
    if ! sudo systemctl status ssh >$dn 2>&1 ; then
        sudo systemctl enable ssh >$dn 2>&1
        sudo systemctl start ssh >$dn 2>&1
    fi

fi

fix_thecommandlinebook >$dn 2>&2

parmanode_conf_remove "patch="
parmanode_conf_add "patch=8"
debug end patch 8
}

########################################################################################

function reduce_systemd_logs {
nogsedtest
[[ -e /etc/systemd/journald.conf ]] && if [[ $OS == Linux ]] ; then
sudo journalctl --vacuum-size=500M >$dn 2>&1
sudo test -f /etc/systemd/journald.conf && sudo gsed -iE 's/^.*SystemMaxUse.*$/SystemMaxUse=500M/' /etc/systemd/journald.conf >$dn 2>&1
fi
}

function fix_thecommandlinebook {
#Faulty download, to fix.
local file="$hp/parman_books/thelinuxcommandlinebook.pdf" 
[[ -e $file ]] || return 1

if ! shasum -a 256 $file 2>$dn | \
    grep -q a86130cb95105d6121541f77fb0c944e9e7b8bf8656266d007288deb2f3a0be5 ; then # FYI, |& pipes bothe std output and std error

pn_tmux "cd $hp/parman_books 
git pull" "linux book patch"

fi
}

