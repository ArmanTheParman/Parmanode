function info_add_drive {
while true ; do
set_terminal ; echo -e " 
########################################################################################

    Using a second drive for Parmanode is possible but the file systems must be
    compatible. For example, you can't import a Parmanode drive used on a Mac to a 
    Linux computer.

   $cyan To bring in an external hard drive that contains Bitcoin blockchain data:$orange
    
      1. Make sure the path to the data is /.bitcoin on the drive - i.e. create a 
         hidden directory called .bitcoin at root directory of the drive (if one
         doesn't already exist), then move the data there.

      2. Continue with the this drive import function and follow the screen prompts
         exactly.
      
      3. Then from the Bitcoin menu, if you're currently syncing to the internal
         drive, you need to select the swap internal/external optio
    $pink     
    You shouldn't attach two Parmanode external drives to the computer simultaneously. 
    Unpredictable things can happen.
$orange
########################################################################################
"
choose "epq" ; read choice
case $choice in q|Q|Quit|QUIT|quit) exit 0 ;; p|P) return 1 ;;
"") break ;; *) invlid ;; esac ; done

}