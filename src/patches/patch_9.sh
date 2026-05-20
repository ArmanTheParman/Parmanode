function patch_9 { debugf


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

    #changing becuase redirection to a log file directly is disfunctional with Fulcrum. Need to do it via script.
    function fulcrum_service_patch { debugf 
    if [[ $OS == "Mac" ]] ; then return 0 ; fi

    local file="/etc/systemd/system/fulcrum.service"
    if $xsudo test -f $file >$dn 2>&1 && cat $file 2>$dn | grep -q "fulcrum.log" ; then 
        return 0
    elif $xsudo test -f $file >$dn 2>&1 ; then #fulcrum.log doesn't exist in file, therefore it's an old version. Remake.
        make_fulcrum_service_file
    fi
    }

remove_tor_log_patch
please_wait
[[ -d /usr/local/bin ]] && sudo strip /usr/local/bin/* >/dev/null 2>&1 
make_external_IP_script
fulcrum_service_patch 
fulcrum_delete_old_log
which tor >$dn && ! grep -q tor-end $ic && installed_conf_add "tor-end"
sudo test -e /etc/sudoers.d/parmanode_extend_sudo_timeout || echo "Defaults:$USER timestamp_timeout=45" | sudo tee /etc/sudoers.d/parmanode_extend_sudo_timeout >/dev/null
parmanode_conf_remove "lndlogfirsttime"
parmanode_conf_remove "patch="
parmanode_conf_add "patch=9"
}