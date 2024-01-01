#code reaches here if external drive selected and drive format not required.

function restore_elctrs_drive {

export original="$parmanode_drive/electrs_db"
export backup="$parmanode_drive/electrs_db_backup"
tempdir="$parmanode_drive/electrs_db_temp"


# Neither exist
if [[ ! -e $backup && ! -e $original ]] ; then
sudo  mkdir $original
return 0
fi

# Only backup exists 
if [[ -e $backup  && ! -e $original ]] ; then 

while true ; do
set_terminal ; echo -e "
########################################################################################

    Parmanode found the directory$cyan electrs_db_backup$orange on the external drive. Do you want 
    to use this directory for this installation of electrs?

                u)         Use it

                del)       Delete it

                i)         Ignore it (makes a new database)

########################################################################################
"
choose "xpmq" ; read choice
case $choice in 

m|M) back2main ;;

u|U)
mv $backup $original
return 0 
;;

del|Del|DEL) 
sudo rm -rf $backup
sudo mkdir $original
return 0 
;;

i|I) 
sudo mkdir $original 
return 0
;;

q|Q) exit 0 
;; 

p|P) 
return 1 
;;

*) 
invalid 
;;

esac
done
fi

# Only original exists
if [[ -e $original && ! -e $backup ]] ; then

while true ; do
set_terminal ; echo -e "
########################################################################################

    Parmanode found the directory$cyan electrs_db$orange on the external drive. Do you want 
    to use this directory for this installation of electrs?

                u)         Use it

                del)       Delete it

########################################################################################
"
choose "xpmq" ; read choice
case $choice in 
m|M) back2main ;;
u|U)
return 0 
;;

del|Del|DEL) 
sudo rm -rf $original 
sudo mkdir $original
return 0 
;;

q|Q) quit 0 
;; 

p|P) 
return 1 
;;

*) 
invalid 
;;

esac
done
fi

# If both exist 
if [[ -e $original && -e $backup ]] ; then

while true ; do
set_terminal ; echo -e "
########################################################################################

    Parmanode found BOTH the directories$cyan electrs_db$orange and$cyan electrs_db_backup$orange on the 
    external drive. 
    
    What do you want to do?

              o)         Use the original (electrs_db)
 
              b)         Use the backup, electrs_db_backup , and delete the original

              db)        Delete both and start fresh

              s)         Use electrs_db_backup, but also back up the original 

########################################################################################
"
choose "xpmq" ; read choice
case $choice in 
m|M) back2main ;;
o|O|original)
return 0 
;;

b|B)
please_wait
sudo rm -rf $original
sudo mv $backup $original
return 0 
;;

db|DB|Db)
sudo rm -rf $original 
sudo rm -rf $backup 
sudo mkdir $original 
;;

q|Q) 
exit 
;; 

s|S)
sudo mv $original $tempdir
sudo mv $backup $original
sudo mv $tempdir $backup
;;

p|P) 
return 1 
;;

*) 
invalid 
;;

esac
done
fi
}