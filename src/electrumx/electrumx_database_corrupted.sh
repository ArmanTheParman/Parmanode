function electrumx_database_corrupted {
while true ; do
set_terminal ; echo "
########################################################################################

    Have you noticed from the log menu that Electrum X's database is corrupted? This
    sometimes happens seemingly for no reason. 

    If this has happened, you need to stop Electrum X, delete the database, and restart
    Electrum x - it's unfortunate, but it means starting over. 

    Do you want Parmanode to clean it up and start Electrum X over for you?

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

if grep -q electrumxdkr < $dp/installed.conf ; then
docker_stop_electrumx
else
stop_electrumx
fi

if [[ $drive_electrumx == external ]] ; then 
         sudo rm -rf $parmanode_drive/electrumx_db
         sudo mkdir $parmanode_drive/electrumx_db
         sudo chown -R $USER $parmanode_drive/electrumx_db
else #drive internal
         rm -rf $HOME/.electrumx_db
         mkdir $HOME/.electrumx_db
fi

break
;;
*) invalid
esac
done
}