function temp_patch {
cleanup_parmanode_service
truncatedebuglog

#Docker containers sometimes won't have $USER variable set...
if [[ -e /.dockerenv && -z $USER ]] ; then
    USER=$(whoami) >/dev/null 2>&1
    echo "USER=$USER ##added by Parmanode" | sudo tee -a $HOME/.bashrc >/dev/null 2>&1
fi

#keep checking in case user declines
tmux_patch

#fix homebrew path order ; remove June 2025
if [[ $OS == Mac ]] && which brew >$dn && [[ -e $bashrc ]] ; then
sudo gsed -i "/\$PATH:\/opt\/homebrew\/bin/d" $bashrc
    if ! grep -q "PATH=/opt/homebrew/bin" $bashrc ; then
    echo "PATH=/opt/homebrew/bin:\$PATH" | sudo tee -a $bashrc >$dn 2>&1
    fi
fi

#leave in temp patch because a single time patch may fail, as docker needs to be running
#remove June 2025 - make sure all electrs docker has socat installed
if grep -q "electrsdkr" $ic ; then
    if ! docker exec -it electrs bash -c "which socat" >/dev/null 2>&1 ; then
        docker exec -d electrs bash -c "sudo apt-get install socat -y" >$dn 2>&1
    fi
fi

#remove in 2025
#because of version2 of electrs install, small bug introduced in the
#install detection. This fixes it.
if grep -q "electrs-start" $ic && grep -q "electrs2-end" $ic ; then
sudo gsed -i "/electrs-start/d" $ic 
parmanode_conf_add "electrs2-start"
fi

if ! grep -q "parmashell" $bashrc ; then
uninstall_parmashell silent ; install_parmashell
fi

#Leave until Mac has a non-docker fulcrum option
if [[ $OS == Mac ]] && grep -q "fulcrum-end" $ic ; then
sudo gsed -i 's/fulcrum-end/fulcrumdkr-end/' $ic >$dn 2>&1 
sudo gsed -i 's/fulcrum-start/fulcrumdkr-start/' $ic >$dn 2>&1 
log "fulcrum" "changed fulcrum-end to fulcrumdkr-end" 
fi

debug temppatchend
}
