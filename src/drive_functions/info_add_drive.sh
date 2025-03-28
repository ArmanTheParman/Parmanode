function info_add_drive {

########################################################################################
if [[ $1 == menu ]] ; then
set_terminal ; echo -e "
########################################################################################
    Please note that if you are importing an Umbrel drive, this is not the function
    to do that - it won't work.
    
    Hit$cyan <enter>$orange to continue, or$cyan a$orange to abort.
########################################################################################
" ; read choice ; set_terminal
if [[ $choice == a || $choice == A ]] ; then return 1 ; fi
fi


########################################################################################

# Starts here...

while true ; do
set_terminal ; echo -e " 
########################################################################################

      Parmanode drives are compatible across different computers, as long as they
      are of the same files system (eg don't try to bring Parmanode drive from Linux
      to a Mac system).

      You shouldn't attach two Parmanode external drives to the computer 
      simultaneously. Terrible things can happen.
    $pink     
      Parmanode will now check if a Parmanode drive is mounted, and if so will stop
      any programs using it and then unmount the drive.
$orange
########################################################################################
"
choose "epmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in q|Q|Quit|QUIT|quit) exit 0 ;; p|P) return 1 ;; m|M) back2main ;; "") break ;; *) invalid ;; 
esac 
done

safe_unmount_parmanode $@ || return 1
}