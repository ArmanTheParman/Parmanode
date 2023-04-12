
function make_bitcoin_directories {
drive=$1


#has the bitcoin directory on parmanode been made? If not, make it.
make_parmanode_bitcoin_directory             

# If external drive - create necessary directories 

make_external_drive_directories              
    # calls format_choice
    # calls delete_dot_bitcoin_directory (+/- make_backup_dot_bitcoin_director)
    # calls set_dot_bitcoin_symlink
                                                                              
                                   
#Internal drive - create directories, and back up if existing.
make_internal_drive_directories
    # check if drive is internal
    # give user options if .bitcoin exists
    # option to call make_bakcup_dot_bitcoin
    # abort bitoin installation if return 1
    if [[ $? == 1 ]] ; then return ; fi 

return 0
}