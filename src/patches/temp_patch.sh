function temp_patch { debugf

#these log files can get massive and freeze the system.
rm -rf ~/.xsessions-errors >$dn 2>&1 ; rm -rf ~/.xsessions-errors.old >$dn 2>&1
debug
if [[ /.dockerenv ]] ; then
    if ! netstat -tuln | grep -q 9050 ; then enable_tor_general ; fi
    #Docker containers sometimes won't have $USER variable set...
    if [[ -z $USER ]] ; then
        USER=$(whoami) >$dn 2>&1
        echo "USER=$USER ##added by Parmanode" | $xsudo tee -a $HOME/.bashrc >$dn 2>&1
    fi
fi

#delete Nov 2026
rm -rf $dp/temp >$dn 2>&1

if ! grep -q "parmashell" $bashrc 2>$dn ; then
uninstall_parmashell silent ; install_parmashell
fi

#Leave until Mac has a non-docker fulcrum option
if [[ $OS == "Mac" ]] && grep -q "fulcrum-end" $ic 2>$dn ; then
gsed -i 's/fulcrum-end/fulcrumdkr-end/' $ic >$dn 2>&1 
gsed -i 's/fulcrum-start/fulcrumdkr-start/' $ic >$dn 2>&1 
fi

# The string "; tlsextradomain" as part of a comment is misinterpreted in a sed command to be
# a directive, causing uncommenting, and a bug.
if [[ -e $HOME/.lnd/lnd.conf ]] && ! grep -q "version 3.47.4" $HOME/.lnd/lnd.conf ; then
    $xsudo gsed -i 's/^.*tlsextradomain.*domains.*$/; The tlsextradomain and tls extraip are used to specify additional domains/' $HOME/.lnd/lnd.conf >$dn 2>&1
    $xsudo gsed -i 's/^; LND.*from version.*$/; LND conf configuration, message added by Parmanode, from version 3.47.4/' $HOME/.lnd/lnd.conf >$dn 2>&1
fi
debug
#remove June 2026
if [[ $OS == "Linux" ]] && test -f $dp/mount_check.sh  ; then

    mv $dp/mount_check.sh $dp/scripts/mount_check.sh >$dn 2>&1 
        #rewrite paths in existing service files
    local bitcoin_service="/etc/systemd/system/bitcoind.service"
    local fulcrum_service="/etc/systemd/system/fulcrum.service"
    local crontabfile="/etc/crontab"
    if $xsudo test -f $bitcoin_service >$dn 2>&1 && $xsudo grep -q 'parmanode/mount_check.sh' $bitcoin_service ; then

    $xsudo gsed -i 's/mount_check.sh/scripts\/mount_check.sh/' $bitcoin_service >$dn 2>&1 
    $xsudo systemctl daemon-reload
    fi

    if $xsudo test -f $fulcrum_service >$dn 2>&1 && $xsudo grep -q 'parmanode/mount_check.sh' $fulcrum_service ; then
    $xsudo gsed -i 's/mount_check.sh/scripts\/mount_check.sh/' $fulcrum_service >$dn 2>&1 
    $xsudo systemctl daemon-reload
    fi

fi 

test -f $hc || touch $dp/hide_commands.conf

#prepare for parmaview
! test -d $dp/parmaview >$dn 2>&1 && mkdir -p $dp/parmaview >$dn 2>&1
! test -f $pvlog >$dn 2>&1 && touch $pvlog
[[ $OS == "Linux" ]] && ! $xsudo test -d /usr/local/bin/parmanode >$dn 2>&1 && { $xsudo mkdir -p /usr/local/bin/parmanode ; $xsudo chown $USER:$USER /usr/local/bin/parmanode ; }
if [[ $OS == "Linux" ]] && $xsudo test -d /usr/local/bin/parmanode && 
                           grep -q "bitcoin-end" $ic && 
                           ! sudo test -f /usr/local/bin/parmanode/bitcoin-cli ; then
    $xsudo mv /usr/local/bin/*bitcoin* /usr/local/bin/parmanode/ >$dn 2>&1
    symlinks_for_bitcoin_binaries >$dn 2>&1
else
debug "$xsudo, $OS, $ic"
fi

#debug temppatchend
}


#changing becuase redirection to a log file directly is disfunctional with Fulcrum. Need to do it via script.
function fulcrum_service_patch { debugf 
if [[ $OS == Mac ]] ; then return 0 ; fi

local file="/etc/systemd/system/fulcrum.service"
if $xsudo test -f $file >$dn 2>&1 && cat $file 2>$dn | grep -q "fulcrum.log" ; then 
    return 0
elif $xsudo test -f $file >$dn 2>&1 ; then #fulcrum.log doesn't exist in file, therefore it's an old version. Remake.
    make_fulcrum_service_file
fi
}

function fulcrum_delete_old_log { debugf
oldfile="/home/parman/parmanode/fulcrum/fulcrum.log"
if cat $ic 2>$dn | grep -q "fulcrumdkr" && docker ps 2>$dn | grep -q "fulcrum" >$dn \
&& docker exec -it fulcrum test -e $oldfile ; then
    announce "Parmanode needs to make some smol adjustments to Fulcrum"
    docker_stop_fulcrum
    docker exec -it fulcrum pkill -15 Fulcrum
    sleep 2
    start_fulcrum
fi

#install rosetta on arm macs to make intel work
if [[ $OS == "Mac" ]] && [[ $(arch) == "arm64" ]] ; then
softwareupdate --install-rosetta --agree-to-license || true
fi
}

function remove_tor_log_patch { debugf

if [[ -e $torrc ]] && grep -q "tornoticefile" $torrc ; then
$xsudo gsed -i '/^.*tornoticefile\.log.*$/d' $torrc >$dn 2>&1
needrestarttor="true"
fi
if [[ -e $torrc ]] && grep -q "torinfofile" $torrc ; then
needrestarttor="true"
$xsudo gsed -i '/^.*torinfofile\.log.*$/d' $torrc >$dn 2>&1
fi
if [[ -n $needrestarttor ]] ; then restart_tor ; fi
unset needrestarttor
}

