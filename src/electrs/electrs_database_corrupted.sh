function electrs_database_corrupted {
while true ; do
set_terminal ; echo "
########################################################################################

    Have you noticed from the log menu that electrs' database is corrupted? This
    sometimes happens seemingly for no reason. 

    If this has happened, you need to stop electrs, delete the database, and restart
    electrs - it's unfortunate, but it means starting over. 

    Do you want Parmanode to clean it up and start electrs over for you?

                        y)      Yes, do it, I can't be bothered

                        n)      No, leave it, I'll try to figure it out myself

######################################################################################## 
"
choose "xpmq" ; read choice ; set_terminal
case $choice in
m|M) back2main ;;
q|Q) exit 0 ;;
p|P) return 0 ;;
n|N|NO|No|no) return 0 ;;
y|Y|YES|Yes|yes) 

if grep -q electrsdkr < $dp/installed.conf ; then
docker_stop_electrs
else
stop_electrs
fi


if [[ $drive_electrs == external ]] ; then 
         sudo rm -rf $parmanode_drive/electrs_db
         sudo mkdir $parmanode_drive/electrs_db
         sudo chown -R $USER $parmanode_drive/electrs_db
else #drive internal
         rm -rf $HOME/parmanode/electrs/electrs_db
         mkdir $HOME/parmanode/electrs/electrs_db
fi

break
;;
*) invalid
esac
done
}