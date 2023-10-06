function info_add_drive {
while true ; do
set_terminal ; echo -e " 
########################################################################################

      Parmanode drives are compatible across different computers, as long as they
      are of the same files system (eg don't try to bring Parmanode drive from Linux
      to a Mac system).

      You shouldn't attach two Parmanode external drives to the computer 
      simultaneously. Terrible things can happen.
    $pink     
      DISCONNECT YOUR REGULAR PARMANODE DRIVE NOW BEFORE ATTEMPTING TO IMPORT A 
      NEW ONE.
$orange
########################################################################################
"
choose "epq" ; read choice
case $choice in q|Q|Quit|QUIT|quit) exit 0 ;; p|P) return 1 ;;
"") break ;; *) invlid ;; esac ; done

}