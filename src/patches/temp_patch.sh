function temp_patch {
cleanup_parmanode_service
truncatedebuglog
truncatexsessions
if [[ -e /.dockerenv ]] && ! netstat -tuln | grep -q 9050 ; then
enable_tor_general
fi

#put in patch 10 later
test -f $dp/.udev_patch || {
    udev_patch && touch $dp/.udev_patch
}

#Docker containers sometimes won't have $USER variable set...
if [[ -e /.dockerenv && -z $USER ]] ; then
    USER=$(whoami) >$dn 2>&1
    echo "USER=$USER ##added by Parmanode" | sudo tee -a $HOME/.bashrc >$dn 2>&1
fi

#delete Nov 2026
rm -rf $dp/temp >$dn 2>&1

#keep checking in case user declines
tmux_patch

#leave in temp patch because a single time patch may fail, as docker needs to be running

if [[ $OS == "Linux" ]] && cat $ic 2>$dn | grep -q "electrs" && ! cat $ic 2>$dn | grep -q "electrsdkr" && ! cat /etc/systemd/system/electrs.service 2>$dn | grep -q "StandardOutput" ; then
please_wait
echo -e "${green}Once off, adjusting electrs service file real quick\n$orange"
sudo gsed -i '/\[Install\]/i\
# Logging\nStandardOutput=append:/home/parman/.electrs/run_electrs.log\nStandardError=append:/home/parman/.electrs/run_electrs.log\n' /etc/systemd/system/electrs.service  >$dn 2>&1
sudo systemctl daemon-reload >$dn 2>&1
sudo systemctl restart electrs >$dn 2>&1
fi

if ! cat $bashrc 2>$dn | grep -q "parmashell" ; then
uninstall_parmashell silent ; install_parmashell
fi

#Leave until Mac has a non-docker fulcrum option
if [[ $OS == "Mac" ]] && cat $ic 2>$dn | grep -q "fulcrum-end" ; then
sudo gsed -i 's/fulcrum-end/fulcrumdkr-end/' $ic >$dn 2>&1 
sudo gsed -i 's/fulcrum-start/fulcrumdkr-start/' $ic >$dn 2>&1 
log "fulcrum" "changed fulcrum-end to fulcrumdkr-end" 
fi

# The string "; tlsextradomain" as part of a comment is misinterpreted in a sed command to be
# a directive, causing uncommenting, and a bug.
if [[ -e $HOME/.lnd/lnd.conf ]] && ! grep -q "version 3.47.4" $HOME/.lnd/lnd.conf ; then
    sudo gsed -i 's/^.*tlsextradomain.*domains.*$/; The tlsextradomain and tls extraip are used to specify additional domains/' $HOME/.lnd/lnd.conf >$dn 2>&1
    sudo gsed -i 's/^; LND.*from version.*$/; LND conf configuration, message added by Parmanode, from version 3.47.4/' $HOME/.lnd/lnd.conf >$dn 2>&1
fi

#can remove in 2026
[[ -e $hp/mempool/docker/docker-compose.yml ]] && 
    gsed -i 's/on-failure/unless-stopped/g' $hp/mempool/docker/docker-compose.yml >/dev/null 2>&1
        
if [[ $OS == Linux ]] && [[ -e /etc/systemd/system/socat.service  ]] ; then
    if grep -q '}' /etc/systemd/system/socat.service ; then
        sudo gsed -i '/}/d' /etc/systemd/system/socat.service >/dev/null 2>&1
        sudoo systemctl daemon-reload >/dev/null 2>&1
        sudo systemctl restart socat.service >/dev/null 2>&1
    fi
fi

#make part of installation later
#having many keys in the .ssh directory causes issues with ssh-agent
mkdir -p $HOME/.ssh/extra_keys >$dn 2>&1
sudo mv ~/.ssh/*-key* $HOME/.ssh/extra_keys/ >$dn 2>&1
[[ -f ~/.ssh/config ]] && 
! grep -q 'extra_keys' ~/.ssh/config && 
sudo gsed -E -i 's|^IdentityFile ~/.ssh/(.*-key)$|IdentityFile ~/.ssh/extra_keys/\1|' ~/.ssh/config >$dn 2>&1

#remove 2026
    gsed -i 's/electrs2/electrs/'       $ic >$dn 2>&1
    gsed -i 's/electrsdkr2/electrsdkr/' $ic >$dn 2>&1

#introduce a scripts directory. Needs some refactoring --- add to patch function later
test -d $dp/scripts || mkdir -p $dp/scripts >$dn 2>&1

mv $dp/update_external_IP2.sh $dp/scripts >$dn 2>&1 #mac and linux ok

if test -f $dp/update_script.sh ; then
    mv $dp/update_script.sh $dp/scripts/update_script.sh >$dn 2>&1
    debug "tmp is $tmp"
    sudo cp /etc/crontab $tmp/crontab && sudo gsed -i 's/parmanode\/update_script.sh/parmanode\/scripts\/update_script.sh/' /$tmp/crontab >$dn 2>&1
    sudo mv $tmp/crontab /etc/crontab >$dn 2>&1
fi

if [[ $OS == "Linux" ]] && test -f $dp/mount_check.sh  ; then

    mv $dp/mount_check.sh $dp/scripts/mount_check.sh >$dn 2>&1 
        #rewrite paths in existing service files
    local bitcoin_service="/etc/systemd/system/bitcoind.service"
    local fulcrum_service="/etc/systemd/system/fulcrum.service"
    local crontabfile="/etc/crontab"
    if sudo test -f $bitcoin_service >$dn 2>&1 && sudo grep -q 'parmanode/mount_check.sh' $bitcoin_service ; then

    sudo gsed -i 's/mount_check.sh/scripts\/mount_check.sh/' $bitcoin_service >$dn 2>&1 
    sudo systemctl daemon-reload
    fi

    if sudo test -f $fulcrum_service >$dn 2>&1 && sudo grep -q 'parmanode/mount_check.sh' $fulcrum_service ; then
    sudo gsed -i 's/mount_check.sh/scripts\/mount_check.sh/' $fulcrum_service >$dn 2>&1 
    sudo systemctl daemon-reload
    fi

fi # end linux

gsed -i 's/vnc-/parmadesk-/g' $ic >$dn 2>&1

if { grep -q vnc- $ic || grep -q parmadesk- $ic ; } && ! test -f $dp/.vncfixed ; then
announce "PARMADESK VNC had some bugs which have been fixed. Please reinstall ParmaDesk"
touch $dp/.vncfixed
fi

#for older installations of parmadesk which didn't have this function #remove in Jan 2026
if grep -q parmadesk-end $ic && ! test -f ~/.asoundrc ; then
    for file in ~/.vnc/*log ; do
    > $file
    done
    make_parmadesk_log_cleanup_service
    sound_error_suppression 
    sudo systemctl restart vnc.service noVNC.service >$dn 2>&1
fi

# if [[ $OS == "Linux" ]] && grep -q parmadesk-end $ic && ! sudo test -f /etc/systemd/system/parmadesk.sh ; then
# make_parmadesk_service
# fi

# would be good to have a run once function, I might make that later and add this in:
test -f $hc || touch $dp/hide_commands.conf

debug temppatchend
}

########################################################################################################################

function truncatexsessions {
#these log files can get massive and freeze the system.
rm ~/.xsessions-errors >$dn 2>&1
rm ~/.xsessions-errors.old >$dn 2>&1
}


#changing becuase redirection to a log file directly is disfunctional with Fulcrum. Need to do it via script.
function fulcrum_service_patch { 
if [[ $OS == Mac ]] ; then return 0 ; fi

local file="/etc/systemd/system/fulcrum.service"
if sudo test -f $file >$dn 2>&1 && cat $file 2>$dn | grep -q "fulcrum.log" ; then 
    return 0
elif sudo test -f $file >$dn 2>&1 ; then #fulcrum.log doesn't exist in file, therefore it's an old version. Remake.
    make_fulcrum_service_file
fi
}

function fulcrum_delete_old_log {
oldfile="/home/parman/parmanode/fulcrum/fulcrum.log"
if cat $ic 2>$dn | grep -q "fulcrumdkr" && docker ps 2>$dn | grep -q "fulcrum" >$dn \
&& docker exec -it fulcrum test -e $oldfile ; then
    announce "Parmanode needs to make some smol adjustments to Fulcrum"
    docker_stop_fulcrum
    docker exec -it fulcrum pkill -15 Fulcrum
    sleep 2
    start_fulcrum
fi

}

function remove_tor_log_patch {

if [[ -e $torrc ]] && grep -q "tornoticefile" $torrc ; then
sudo gsed -i '/^.*tornoticefile\.log.*$/d' $torrc >$dn 2>&1
needrestarttor="true"
fi
if [[ -e $torrc ]] && grep -q "torinfofile" $torrc ; then
needrestarttor="true"
sudo gsed -i '/^.*torinfofile\.log.*$/d' $torrc >$dn 2>&1
fi
if [[ -n $needrestarttor ]] ; then restart_tor ; fi
unset needrestarttor
}

