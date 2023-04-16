function install_parmanode {

set_terminal

install_check "parmanode-start" #checks parmanode.conf, and exits if already installed.
    if [ $? == 1 ] ; then return 1 ; fi #error mesages done in install_check, this ensures code exits to menu

if [[ $OS == "Linux" ]] ; then update_computer ; fi
if [[ $OS == "Mac" ]] ; then 
	brew_check 
	if [ $? == 1 ] ; then return 1 ; fi   #returns to menu if user chose "p" inside function 
	bitcoin_dependencies 
	if [ $? == 1 ] ; then return 1 ; fi   #returns to menu if user chose "p" inside function 
fi

#Test for necessary functions
sudo_check
gpg_check

choose_and_prepare_drive_parmanode # Sets $hdd value. format_external_drive, if external
return_value=$?
if [[ $return_value == "1" ]] ; then return 1 ; fi
if [[ $return_value == "2" ]] ; then return 2 ; fi

home_parmanode_directories # parmanode-start entered in config file within the nest of functions as soon as drive edited.
if [ $? == 1 ] ; then return 1 ; fi #exiting this function with return 1 takes user to menu.

# Update config files
    parmanode_conf_add "drive=$hdd" #make parmanode config file, sets drive value to $hdd
    installed_config_add "parmanode" #add parmanode to installed config file (installed.conf)
    installed_config_add "parmanode-end" #add parmanode to installed config file (installed.conf)
    #extra entry made for now, but as code is cleaned up, only "parmanode-end" is required

set_terminal ; echo "
########################################################################################
    
                                      Success
                                      				    
    Parmanode has been installed. You can now go ahead in install Bitcoin Core from 
    the instalation menu.

########################################################################################

"
enter_continue

return 0
}


