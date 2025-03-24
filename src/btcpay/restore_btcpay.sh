function restore_btcpay {
while true ; do
unset fileselected
if [[ -e $HOME/Desktop/btcpay_parmanode_backup.tar ]] ; then

    if yesorno "Do you want to use this file to restore?\n  $green
            \r    $HOME/Desktop/btcpay_parmanode_backup.tar$orange" "y" "Yes" "n" "No, something different" ; then
        fileselected="true"
        file="$HOME/Desktop/btcpay_parmanode_backup.tar"    
    fi
fi

if [[ -z $fileselected ]] ; then
set_terminal ; echo -e "
########################################################################################

    Please type the full path of the parmanode backup file, eg:
$cyan
        $HOME/Desktop/btcpay_parmanode_backup.tar
$red
    Remember, on Linux, paths are case sensitive.$orange
########################################################################################
"
choose xpmq ; read file ; set_terminal
jump $file || { invalid ; continue ; } ; set_terminal
case $file in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;; "") invalid ;;
esac
fi

#verify file
if [[ ! -f $file ]] ; then announce "The file doesn't exist - $file" ; continue ; fi
if ! tar -tf $file | grep -q "btcpayserver.sql" ; then 
announce "This tar file is missing btcpayserver.sql inside. Aborting."
return 0
fi
break
done

#copy backup to the container
containerfile="/home/parman/backup.tar"
containerdir="/home/parman/backupdir"
containerdb="$containerdir/btcpayserver.sql"
restore_log="/var/lib/postgresql/restore_log.txt"
podman exec -itu parman btcpay /bin/bash -c "rm -rf $containerdir ; mkdir $containerdir"

if ! podman cp $file btcpay:$containerfile ; then 
    #copy didn't work. clean up...
    podman exec -itu root btcpay rm -rf $containerdir
    podman exec -itu root btcpay rm -rf $containerfile
    enter_continue "Something went wrong copying the backup to the container"
    return 1
fi 

#extract the tar file
please_wait
if ! podman exec -itu parman btcpay /bin/bash -c "tar -xvf $containerfile -C $containerdir" ; then
    #extract didn't work. clean up...
    podman exec -itu root btcpay rm -rf $containerdir
    podman exec -itu root btcpay rm -rf $containerfile
    enter_continue "Something went wrong extracting the backup in the container"
    return 1
fi

#Check psql db file is valid
if ! podman exec -itu parman btcpay /bin/bash -c "grep -iq 'PostgreSQL database dump' $containerdb" ; then
    yesorno "Doesn't seem to be a valid Postgres SQL file.\n    Ignore error and proceed to import?" || {
        podman exec -itu root btcpay rm -rf $containerdir
        podman exec -itu root btcpay rm -rf $containerfile
        return 1
    }
fi

#stop databases
#echo -e "\n${green}Stopping databases...$orange"
#podman exec -itu postgres btcpay /bin/bash -c "psql -U postgres -c \"SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname IN ('btcpayserver', 'nbxplorer', 'postgres');\" " >$dn 2>&1

# #delete first to avoid merging - the other databases don't matter.
#     if ! podman exec -itu postgres btcpay bash -c "psql -U postgres -c 'DROP DATABASE IF EXISTS btcpayserver;'" \
#         && podman exec -itu postgres btcpay bash -c "psql -U postgres -c 'DROP DATABASE IF EXISTS nbxplorer;'" \
#         && podman exec -itu postgres btcpay bash -c "psql -U postgres -c 'DROP DATABASE IF EXISTS postgres;'"  
#     then    
#         podman exec -itu root btcpay rm -rf $containerdir
#         podman exec -itu root btcpay rm -rf $containerfile
#         enter_continue "Something went wrong during database preparation. Aborting." 
#         return 1
#     fi

#restore directories - delete first then copy in. Preserve settings file first.
cp $HOME/.btcpayserver/Main/settings.config $HOME/.btcpayserver/settings.config_backup 2>$dn
podman exec -itu root btcpay rm -rf /home/parman/.btcpayserver/Main 2>$dn
podman exec -itu root btcpay rm -rf /home/parman/.btcpayserver/Plugins 2>$dn

if ! podman exec -itu parman btcpay cp -r $containerdir/Main /home/parman/.btcpayserver/Main ; then
    announce "Something went wrong - couldn't copy Main directory. Aborting."
    return 1
fi

if ! podman exec -itu parman btcpay mv $containerdir/Plugins /home/parman/.btcpayserver/Plugins ; then
    announce "Something went wrong - couldn't copy Plugins directory. Aborting."
    return 1
fi

mv $HOME/.btcpayserver/settings.config_backup $HOME/.btcpayserver/Main/settings.config >$dn 2>&1

#restore databases
if podman exec -itu postgres btcpay bash -c "psql < $containerdb | tee $restore_log 2>&1" ; then 
    debug "after restore psql"
    podman exec -itu root btcpay bash -c "rm $containerfile" 
    podman exec -itu root btcpay rm -rf $containerdir
    success "Backup restored" 
    return 0
else
    podman exec -itu root btcpay rm -rf $containerdir
    podman exec -itu root btcpay rm -rf $containerfile
    enter_continue "Something went wrong with the import procedure. Aborting." ; jump $enter_cont 
    return 1
fi
}