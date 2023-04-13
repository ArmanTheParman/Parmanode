function make_internal_drive_directories {
#proceed only if internal drive selected.
    if [[ $drive == "internal" ]]
    then true
    else return 1
    fi

# If .bitcoin directory exists, decide what to do with it.
# If it doesn't exists, do nothing, running bitcoind will create it automatically.

if [[ -d $HOME/.bitcoin ]]
then 

while true #menu loop
do
set_terminal
echo "
########################################################################################

           $HOME/.bitcoin (Bitcoin data directory) already exists

    Would you like to:

            (d)         Start fresh and delete the files/directories contained 
                        within

            (yolo)      Use the existing .bitcoin data directory (be careful)

            (b)         Make a backup copy as ".bitcoin_backup", and start fresh

    If using the existing directory (yolo), be aware Parmanode might make changes 
    to its contents, and you could get unexpected behaviour.       

########################################################################################
"     
choose "xq"

read choice

set_terminal

case $choice in

    d|D) #delete
        rm -rf $HOME/.bitcoin/
        echo ".bitcoin directory deleted."
        enter_continue
	set_terminal
        break
        ;;

    yolo|YOLO) #use existing .bitcoin directory and contents
        echo "
        Using exiting .bitcoin directory"
        enter_continue
        break
        ;;

    b|B) #back up directory
        make_backup_dot_bitcoin                 #original directory deleted by a "move"
        break
        ;;

    q|Q|quit|QUIT)
        exit 0
        ;;
        
    *)
        invalid
        continue ;;
esac

done 
else
    mkdir $HOME/.bitcoin >/dev/null 2>&1
fi 
return 0
}
