function info_add_drive {
while true ; do
set_terminal ; echo -e " 
########################################################################################

    Using a second drive for Parmanode is possible but the file systems must be
    compatible. For example, you can't import a Parmanode drive used on a Mac to a 
    Linux computer.

   $cyan To bring in an external hard drive that contains Bitcoin blockchain data:$orange
    
      1. Make sure the path to the data is /.bitcoin on the drive - i.e. create a 
         hidden directory called .bitoin at root directory of the drive, then move 
         the data there.

      2. Continue with the this drive import function and follow the screen prompts
         exactly.

      3. Then install Bitcoin (uninstall first if you have it already) using 
         Parmanode. You will be asked if you want and internal or external drive.
         Choose external drive, then select to skip formatting when prompted.

      4. Once the Bitcoin installation is finished, the program will be using
         the newly imported drive to sync blocks. 

    You shouldn't attach two Parmanode external drives to the computer simultaneously. 
    Unpredictable things can happen.

########################################################################################
"
choose "epq" ; read choice
case $choice in q|Q|Quit|QUIT|quit) exit 0 ;; p|P) return 1 ;;
"") break ;; *) invlid ;; esac ; done

}