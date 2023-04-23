function install_parmanode {

set_terminal

install_check "parmanode" #checks parmanode.conf, and exits if already installed.
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
curl_check
make_dot_parmanode

choose_and_prepare_drive_parmanode # Sets $hdd value. format_external_drive, if external
    return_value=$?
    if [[ $return_value == "1" ]] ; then return 1 ; fi
    if [[ $return_value == "2" ]] ; then return 2 ; fi

make_home_parmanode 
    if [ $? == 1 ] ; then return 1 ; fi #exiting this function with return 1 takes user to menu.

# Update config files
    parmanode_conf_add "drive=$hdd" 
    installed_config_add "parmanode-end" 

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


