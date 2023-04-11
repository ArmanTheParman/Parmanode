function make_external_drive_directories {

if [[ $drive == "external" ]]
    then
    format_choice                           # a chance to format drive again if not done before.
                                            # if .bitcoin exists, and, isn't a symlink, user 
                                            # to decide to wipe or back up.
                                            # create symlink later. Double check.
delete_dot_bitcoin_directory                                        
set_dot_bitcoin_symlink
mkdir /media/$(whoami)/parmanode/.bitcoin && return 0
debug_point "Error - failed to make .bitcoin directory on external drive. Aborting."
exit 1
fi
return 1 
}