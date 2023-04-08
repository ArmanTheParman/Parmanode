function install_parmanode {


set_terminal

install_check "parmanode-start" #checks parmanode.conf, and exits if already installed.
    if [ $? == 1 ] ; then return 1 ; fi #error mesages done in install_check, this ensures code exits to menu

update_computer

choose_and_prepare_drive_parmanode # Sets $hdd value. format_external_drive, if external

home_parmanode_directories # parmanode-start entered in config file within the nest of functions as soon as drive edited.
if [ $? == 1 ] ; then debug_point "exiting out of home pn dir" ; return 1 ; fi

parmanode_conf_add "drive=$hdd" #make parmanode config file, sets drive value to $hdd

installed_config_add "parmanode" #add parmanode to installed config file (installed.conf)
installed_config_add "parmanode-end" #add parmanode to installed config file (installed.conf)
#extra entry made for now, but as code is cleaned up, only "parmanode-end" is required

set_terminal 

echo "
########################################################################################
    
                                      Success
                                      				    
    Parmanode has been installed. You can now go ahead in install Bitcoin Core from 
    the instalation menu.

########################################################################################

"
enter_continue
debug "weird"
return 0


}


