function restore_nostr_data_backup {

if ls -d $HOME/.nostr_data_backup* >/dev/null 2>&1 || ls -d $pd/nostr_data_backup >/dev/null 2>&1 ; then

set_terminal ; echo -e "
########################################################################################

    Parmanode has found an old backup nostr relay directory. If you wish to use this,
    then continue with the installation, and when finished, stop the relay, move
    the backup directory to the target location, then restart the relay.


                            Internal Drive Location:
$cyan         
    $HOME/.nostr_relay
$orange
                            External Drive Location:
$cyan
    $pd/nostr_relay
$orange        

    Do note the differences between the two, there is no '.' in the External drive
    path

########################################################################################
"
enter_continue
fi
}