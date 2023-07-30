function install_parmanode {

set_terminal

install_check "parmanode" #checks parmanode.conf, and exits if already installed.
    if [ $? == 1 ] ; then return 1 ; fi #error mesages done in install_check, this ensures code exits to menu

curl -s https://parman.org/downloadable/parmanode_${version}_install_parmanode_counter >/dev/null 2>&1 &

update_computer 

if [[ $OS == "Mac" ]] ; then 

	brew_check 
	if [ $? == 1 ] ; then return 1 ; fi   

    greadlink_check 
        
fi

#Test for necessary functions
sudo_check
gpg_check
curl_check
make_dot_parmanode

    #changing to make drive selection only during bitcoin installation.
    #choose_and_prepare_drive_parmanode # Sets $hdd value. format_external_drive, if external
    #    return_value=$?
    #    if [[ $return_value == "1" ]] ; then return 1 ; fi
    #    if [[ $return_value == "2" ]] ; then return 2 ; fi

make_home_parmanode 
    if [ $? == 1 ] ; then return 1 ; fi #exiting this function with return 1 takes user to menu.
        
# Update config files

#   parmanode_conf_add "drive=$hdd" 
    installed_config_add "parmanode-end" 

# Set variables
    Linux_distro

while true ; do
set_terminal ; echo "
########################################################################################
    
                                 S U C C E S S  ! ! 
                                      				    
    Parmanode has been installed. Install Bitcoin now? 

                           y)      Yes, install Bitcoin

                           n)      No, I might do it later

########################################################################################
"
choose "xq" ; read choice
case $choice in
    y|Y|YES|Yes|yes) install_bitcoin ; return 0 ;;
    n|N|No|NO|no) break ;;
    *) invalid ;;
    esac 
done    
return 0
}


