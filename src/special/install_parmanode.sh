function install_parmanode {

set_terminal

make_home_parmanode 
make_dot_parmanode 

# With no argument after the function, this will create a parmanode.conf file if it doesnt' exist.
parmanode_conf_add

# Update config files - make redundant later.
     installed_config_add "parmanode-start"
     installed_config_add "parmanode-end" # This syntax, -start and -end, helps identifiy installations
    #that have started vs installations that have completed.

# Load config variables
source $HOME/.parmanode/parmanode.conf >/dev/null 2>&1 

#if docker is set up on the machine, then it is detected by Parmanode
#and added to the config file
if [[ -f $HOME/.parmanode/installed.conf ]] ; then #execute only if an installed config file exits otherwise not point.
	if [[ $(uname) == Darwin ]] || (id | grep -q docker && which docker >/dev/null ) ; then
		if ! grep -q docker-end < $HOME/.parmanode/installed.conf ; then
			installed_config_add "docker-end" 
		fi
	fi
fi

# fix fstab for older parmanode versions. This is a bug fix which will soon be obsolete.
# In older versions there was a field missing in fstab which caused a system crash if
# the drive was physically disconnected during a reboot.
fix_fstab ; fix_services 


########################################################################################
#Intro
########################################################################################
set_terminal # custom function for screen size and colour.
if [[ $skip_intro != "true" ]] ; then intro ; instructions ; fi



# a self explanatory custom function
if [[ -e $HOME/.parmanode/.new_install ]] ; then
update_computer 
rm $HOME/.parmanode/.new_install
else
autoupdate
fi

fix_autoupdate

# Send alert message if needed ; alert=true/false captured.
#curl -sf https://parmanode.com/alert | sh

#Test for necessary functions
sudo_check # needed for preparing drives etc.
gpg_check  # needed to download programs from github
curl_check # needed to download things using the command prompt rather than a browser.

if [[ $OS == "Mac" ]] ; then 

	brew_check  # brew needs to be installed for parmanode to work on macs
                # if skipped, will ask each time parmanode is run

    greadlink_check  # For macs, this function is needed for text manipulation functions I'll be making.
        
fi
ensure_english
check_architecture
add_rp_function
correct_old_installation
parmanode1_fix
git_dp
if [[ -z $lnd_port ]] ; then export lnd_port=9735 ; fi #Line added version 3.14.1
}




