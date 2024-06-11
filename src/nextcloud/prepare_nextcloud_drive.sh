function prepare_nextcloud_drive {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
    NextCloud needs to store your data somewhere. You have choices.
$orange
        1) Use the default, an hidden directory on your internal drive
$bright_blue
            /var/lib/docker/volumes/nextcloud_aio_nextcloud_data/_data/ $orange

        2) Use a custom directory of your choice (internal or external drive)

########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
1)
export drive_nextcloud="default"
parmanode_conf_add "drive_nextcloud=default"
parmanode_conf_add "nextcloud_dir=/var/lib/docker/volumes/nextcloud_aio_nextcloud_data/_data/"
return 0
;;
2)
export drive_nextcloud="custom"
parmanode_conf_add "drive_nextcloud=custom"
enter_custom_nextcloud_drive || return 1
return 0
;;
*)
invalid
;;
esac
done
}

function enter_custom_nextcloud_drive {
while true ; do
unset nextclouddir
set_terminal ; echo -e "
########################################################################################

    Please type the$cyan full path$orange of your custom directory for your NextCloud data.

    Eg, if it's on the external drive, it might be something like...
$cyan
       /media/$USER/my_drive/NextCloud_data/ $orange

    Or, maybe like this if it's on the internal drive, your choice:
$cyan
       $HOME/NextCloud_data/
$orange    
    Please make sure the directory you choose already exists or installation will
    fail. You can open a new terminal window to sort this out now, and come back
    to this installation wizard.

    Type the path and hit$green <enter>$orange to continue.

########################################################################################
"
choose xpmq ; read nextclouddir ; set_terminal
case $nextclouddir in
q|Q) quit ;; p|P) return 1 ;; m|M) back2main ;;
*)
# enter or 1 or 2 character entries are invalid
if [[ $(echo $nextclouddir | wc -c) -lt 3 ]] ; then invalid ; continue ; fi

set_terminal ; echo -e "
########################################################################################


    You entered: $nextclouddir


                                y) to accept

                                n)  to try again


########################################################################################
"
choose xpmq ; read choice ; set_terminal
if [[ $choice == y ]] ; then break ; else continue ; fi
;;

esac
done

parmanode_conf_add "nextcloud_dir=$nextclouddir"
source $pc

}