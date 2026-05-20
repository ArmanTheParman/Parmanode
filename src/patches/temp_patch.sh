function temp_patch { debugf
cleanup_parmanode_service
#sudo rm $pn/debug.log >$dn 2>&1

#these log files can get massive and freeze the system.
sudo rm -rf ~/.xsessions-errors* >$dn 2>&1 

if [[ -e /.dockerenv ]] && ! netstat -tuln | grep -q 9050 ; then
enable_tor_general
fi

#Docker containers sometimes won't have $USER variable set...
if [[ -e /.dockerenv && -z $USER ]] ; then
    USER=$(whoami) >$dn 2>&1
    echo "USER=$USER ##added by Parmanode" | $xsudo tee -a $HOME/.bashrc >$dn 2>&1
fi

#delete Nov 2026
rm -rf $dp/temp >$dn 2>&1

#keep checking in case user declines
which tmux >$dn 2>&1 || tmux_patch

#install parmashell
if ! cat $bashrc 2>$dn | grep -q "parmashell" ; then
uninstall_parmashell silent ; install_parmashell
fi

#Leave until Mac has a non-docker fulcrum option
if [[ $OS == "Mac" ]] && cat $ic 2>$dn | grep -q "fulcrum-end" ; then
$xsudo gsed -i 's/fulcrum-end/fulcrumdkr-end/' $ic >$dn 2>&1 
$xsudo gsed -i 's/fulcrum-start/fulcrumdkr-start/' $ic >$dn 2>&1 
log "fulcrum" "changed fulcrum-end to fulcrumdkr-end" 
fi

#make part of installation later
#having many keys in the .ssh directory causes issues with ssh-agent
mkdir -p $HOME/.ssh/extra_keys >$dn 2>&1
$xsudo mv ~/.ssh/*-key* $HOME/.ssh/extra_keys/ >$dn 2>&1
[[ -f ~/.ssh/config ]] && 
! grep -q 'extra_keys' ~/.ssh/config && 
$xsudo gsed -E -i 's|^IdentityFile ~/.ssh/(.*-key)$|IdentityFile ~/.ssh/extra_keys/\1|' ~/.ssh/config >$dn 2>&1


if [[ $($xsudo grep -cq "Additions by Parmanode" $torrc 2>$dn) -gt 1 ]] ; then
    remove_tor_general
    enable_tor_general
fi

#Fix /dev/null - sometimes due to typo, /dev/null permission can be changed.
#Considering adding this patch; not sure yet.
    #   sudo chmod 0666 /dev/null


debug temppatchend
}
