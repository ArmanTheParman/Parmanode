function next_patch { debugf
#for patch 11
test -d $dp/scripts || mkdir -p $dp/scripts >$dn 2>&1
mv $dp/update_external_IP2.sh $dp/scripts >$dn 2>&1 #mac and linux ok
if test -f $dp/update_script.sh ; then
    mv $dp/update_script.sh $dp/scripts/update_script.sh >$dn 2>&1
    $xsudo cp /etc/crontab $tmp/crontab && $xsudo gsed -i 's/parmanode\/update_script.sh/parmanode\/scripts\/update_script.sh/' /$tmp/crontab >$dn 2>&1
    $xsudo mv $tmp/crontab /etc/crontab >$dn 2>&1
fi

if [[ $OS == "Linux" ]] && test -f $dp/mount_check.sh >$dn 2>&1 ; then

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

#Remove in 2027 (code added to install_mempool function Version 3.69.5+)
    if [[ -z $docker_bridge ]] && docker ps >$dn 2>&1 ; then
        export docker_bridge=$(docker network inspect bridge | jq -r '.[0].IPAM.Config[0].Gateway')
        if [[ $docker_bridge =~ ^[0-9] ]] ; then #check if value is valid
            echo "docker_bridge=$docker_bridge" | tee -a $pc >$dn 2>&1
            [[ $OS == "Linux" ]] && sudo gsed -i "s/ CORE_RPC_HOST.*\$/ CORE_RPC_HOST: \"$docker_bridge\"/" $mempoolconf >$dn 2>&1
            [[ $OS == "Linux" ]] && sudo gsed -i "s/ ELECTRUM_HOST.*\$/ ELECTRUM_HOST: \"$docker_bridge\"/" $mempoolconf >$dn 2>&1
        fi
    fi

#Make symlink
if test -f $hp/electrum/*AppImage && ! test -L $hp/electrum/electrum ; then
    ln -s $hp/electrum/*AppImage $hp/electrum/electrum
fi   


parmanode_conf_remove "bip110choice="

make_bitcoind_service_file "setup"
make_electrs_serivce_file "setup"
make_fulcrum_serivce_file "setup"
sudoers_patch #service files will be created and moved to /usr/local/parmanode for later access, so copy command added
return 0


}