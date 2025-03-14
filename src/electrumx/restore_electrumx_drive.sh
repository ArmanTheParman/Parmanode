#code reaches here if external drive selected and drive format not required.
function restore_electrumx_drive {

export original="$parmanode_drive/electrumx_db"
export backup="$parmanode_drive/electrumx_db_backup"
tempdir="$parmanode_drive/electrumx_db_temp"


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

    Parmanode found the directory$cyan electrumx_db_backup$orange on the external drive. Do you want 
    to use this directory for this installation of Electrum X?
$green
                u)         Use it
$red
                del)       Delete it
$white
                i)         Ignore it (makes a new database)
$orange
########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;

u|U)
sudo mv $backup $original
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

    Parmanode found the directory$cyan electrumx_db$orange on the external drive. Do you want 
    to use this directory for this installation of Electrum X?
$green
                u)         Use it
$red
                del)       Delete it
$orange
########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
u|U)
return 0 
;;

del|Del|DEL) 
sudo rm -rf $original 
sudo mkdir $original
return 0 
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

    Parmanode found BOTH the directories$cyan electrumx_db$orange and$cyan electrumx_db_backup$orange on the 
    external drive. 
    
    What do you want to do?
$cyan
              o)$orange         Use the original (Electrumx_db)
$cyan 
              b)$orange         Use the backup, electrumx_db_backup , and delete the original
$cyan
              db)$orange        Delete both and start fresh
$cyan
              s)$orange         Use electrumx_db_backup, but also back up the original 

########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
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

s|S)
sudo mv $original $tempdir
sudo mv $backup $original
sudo mv $tempdir $backup
;;
*) 
invalid 
;;

esac
done
fi
}