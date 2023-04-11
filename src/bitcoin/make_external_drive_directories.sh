function make_external_drive_directories {

if [[ $drive == "external" ]]
    then
    format_choice                           # a chance to format drive again if not done before.
                                            # if .bitcoin exists, and, isn't a symlink, user 
                                            # to decide to wipe or back up.
                                            # create symlink later. Double check.
delete_dot_bitcoin_directory                                        
set_dot_bitcoin_symlink
if $(mkdir /media/$(whoami)/parmanode/.bitcoin) ; then
    return 0
    else #make directory command fails becuase directory already exits
        while true ; do
        set_terminal
        echo "
########################################################################################

    A data directory already exits on the external drive.
    
    You have options:

                    b)     Parmanode will back-up the directory on the
                           external drive (Do you really have the space?)
                    
                    d)     Delete and make new directory

                    s)     Skip - ie use existing .bitcoin directory on ext drive

########################################################################################
"
        choose "xq" ; read choice
        case $choice in 

            b|B) make_backup_dot_bitcoind && return 0 ;;

            d|D) rm -rf /media/$(whoami)/parmanode/.bitcoin && mkdir /media/$(whoami)/parmanode/.bitcoin && return 0 ;;
            
            s|S) return 0 ;;

            q|Q|quit|Qui|QUIT) exit 0 ;;

            *) invalid ;;
            esac
        done
    fi #ends mkdir if
        
exit 1
fi
return 1 
}