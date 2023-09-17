#code reaches here if drive format not required.

function restore_elctrs_drive {

[[ -d /media/$USER/parmanode/electrs_db_backup ]] && dirname=electrs_db_backup
[[ -d /media/$USER/parmanode/electrs_db ]] && dirname=electrs_db #swaps dirname because this one is higher priority
[[ $dirname == electrs_db_backup ]] && output="i)         Ignore it" #for formatting the next menu

while true ; do
set_terminal ; echo "
########################################################################################

    Parmanode found the directory $dirname on the external drive. Do you want 
    to use this directory for this installation of electrs?

                u)         Use it

                del)       Delete it
"
echo -n "                $output"
echo "

########################################################################################
"
choose "xpq" ; read choice
case $choice in q|Q) quit 0 ;; p|P) return 1 ;;
#if "use it" selected, that's the only case where a new electrum_db directory won't be created.
#"ignore it" is only available if the directory is not called electrum_db, so it's all good.
#The variable electrum_db_restore is needed for the function prepare_drive_electrs
u|U)
export electrs_db_restore="true" 
mv /media/$USER/parmanode/$dirname /media/$USER/parmanode/electrs_db
break ;;
del|Del|DEL) sudo rm -rf /media/$USER/parmanode/$dirname ; export electrs_db_restore="false" ; break ;;
i|I) unset dirname ; electrs_db_restore="false" ; break ;;
*) invalid
esac
done


}