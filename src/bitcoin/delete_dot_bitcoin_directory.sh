function delete_dot_bitcoin_directory {                        
#.bitcoin will be deleted if it exists and is not a symlink.

if [[ -d "$HOME/.bitcoin" && ! -L "$HOME/.bitcoin" ]]        
then
# .bitcoin directory exists on internal drive"
while true
do
set_terminal
echo "
########################################################################################

    The directory:
    
                $HOME/.bitcoin
    
    currently already exists on your internal drive. It has a size of: 
    
                $(du -sh $HOME/.bitcoin | cut -f1)

    Even though you are using an external drive for the Bitcoin data directory,
    this internal drive's directory is needed to "direct traffic" to the external 
    drive by a symlink, also known as a "shorcut" to Windows users.

    To continue with an external drive, the .bitcoin directory needs to either be 
                        
                        deleted (d)  ----> reckless?

                        backed up (b) and renamed to .bitcoin_backup. 

    A symlink to the external drive will be created in its place and named
    $HOME/.bitcoin.

    Note that the \".\" in front of bitcoin means it's a hidden directory.

    The backup you make can be deleted later. If you know what you're doing, you can 
    move the backup directory to the original location to use that copy of the 
    blockchain data should you ever need.

########################################################################################
"
choose "xq"
read choice
set_terminal

    case $choice in
        d)                                      #User chooses to delete existing data directory.
            sudo rm -rf $HOME/.bitcoin 
            break
            ;;
        b)                                      #User chooses to back up existing data directory, and original is deleted.
            make_backup_dot_bitcoin             
            break
            ;;
        *)
            invalid
            ;;

        q | quit | Q)
            exit 0
            ;;
        esac

done 
else
    true # nothing do do, there should be no .bitcoin in the HOME directory. Will make symlink later.
fi     


return 0
}
