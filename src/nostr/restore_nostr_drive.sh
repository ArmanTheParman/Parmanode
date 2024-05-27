#code reaches here if external drive selected and drive format not required.
function restore_nostr_drive {

export original="$parmanode_drive/nostr_data"
export backup="$parmanode_drive/nostr_data_backup"
tempdir="$parmanode_drive/nostr_data_temp"


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

    Parmanode found the directory$cyan nostr_data_backup$orange on the external drive. Do you want 
    to use this directory for this installation of Nostr Relay?
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
case $choice in 

m|M) back2main ;;

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

    Parmanode found the directory$cyan nostr_data$orange on the external drive. Do you want 
    to use this directory for this installation of Nostr Relay?
$green
                u)         Use it
$red
                del)       Delete it
$orange
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

    Parmanode found BOTH the directories$cyan nostr_data$orange and$cyan nostr_data_backup$orange on the 
    external drive. 
    
    What do you want to do?

              o)         Use the original (nostr_data)
 
              b)         Use the backup, nostr_data_backup , and delete the original

              db)        Delete both and start fresh

              s)         Use nostr_data_backup, but also back up the original 

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