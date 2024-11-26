function temp_patch {
cleanup_parmanode_service
truncatedebuglog
truncatexsessions
remove_tor_log_patch
#move to next patch, patch 8
    reduce_systemd_logs 
    fulcrum_service_patch 

fulcrum_delete_old_log 

#Docker containers sometimes won't have $USER variable set...
if [[ -e /.dockerenv && -z $USER ]] ; then
    USER=$(whoami) >$dn 2>&1
    echo "USER=$USER ##added by Parmanode" | sudo tee -a $HOME/.bashrc >$dn 2>&1
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
    if ! docker exec -it electrs bash -c "which socat" >$dn 2>&1 ; then
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

function truncatexsessions {
#these log files can get massive and freeze the system.
rm ~/.xsessions-errors >$dn 2>&1
rm ~/.xsessions-errors.old >$dn 2>&1
}


#changing becuase redirection to a log file directly is disfunctional with Fulcrum. Need to do it via script.
function fulcrum_service_patch { 
if [[ $OS == Mac ]] ; then return 0 ; fi

local file="/etc/systemd/system/fulcrum.service"
if sudo test -f $file >$dn 2>&1 && grep -q "fulcrum.log" $file ; then 
    return 0
elif sudo test -f $file >$dn 2>&1 ; then #fulcrum.log doesn't exist in file, therefore it's an old version. Remake.
    debug "fulcrum startup mods..."
    make_fulcrum_service_file
fi
debug "end fulcrum service patch"
}

function fulcrum_delete_old_log {
oldfile="/home/parman/parmanode/fulcrum/fulcrum.log"
if grep -q "fulcrumdkr" $ic && docker ps 2>$dn | grep -q "fulcrum" >$dn \
&& docker exec -it fulcrum test -e $oldfile ; then
    announce "Parmanode needs to make some smol adjustments to Fulcrum"
    docker_stop_fulcrum
    docker exec -it fulcrum pkill -15 Fulcrum
    sleep 2
    start_fulcrum
fi

}


# function manage_logs {
# local file="$hp/startup_scripts/manage_logs"

# cat <<'EOF' tee $file >/dev/null
# #!/bin/bash

# while true ; do

# [[ $(cat $HOME/.fulcrum/fulcrum.log | wc -l) -gt 10000 ]] && \
#     if [[ $(uname) == Linux ]] ; then
#         pkill Fulcrum    
#         tail -n100 $HOME/.ful




# EOF
# sudo chmod +x $file 

# }

function remove_tor_log_patch {

if [[ -e $torrc ]] && grep -q "tornoticefile.log" $torrc ; then
gsed -i '/^.*tornoticefile.log.*$/d' $torrc >$dn 2>&1
needrestarttor="true"
fi

if [[ -e $torrc ]] && grep -q "torinfofile.log" $torrc ; then
needrestarttor="true"
gsed -i '/^.*torinfofile.log.*$/d'   $torrc >$dn 2>&1
fi

if [[ -n $needrestarttor ]] ; then restart_tor ; fi
debug "remove tor log patch"
unset needrestarttor
}