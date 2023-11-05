#Called by run_parmanode

function do_loop {
#Educational comments included.

#The first line, including the # is treated specially. It means this is
#a script, and invokes the bash program to run it. It must be the very first
#character in a file followed by !, then the path to the terminal program.


#check script is being run from parmanode directory so relative paths work
#-f checks if a file exists in the working directory. If it doesn't, it 
#means the run_parmanode.sh file is not in the correct location.
if [ -f do_not_delete_move_rename.txt ] ; then true ; else
clear
echo "
The run_parmanode.sh script must be run from it's original directory. It
cannot be moved relative to all the other files, but it can be run
by calling it with a different script from elsewhere.

Exiting. Hit <enter> to exit."
read #this command takes any user keyboard input, waiting for <enter> to continue.
exit 0
fi

# source all the modules. Exclude executable scripts which aren't modules. Modules
# are bits of codes saved elseshere. They are "sourced" to load the code into memory.

	for file in ./src/**/*.sh ; do #for every file that ends in .sh, attach its
	#name to the variable "file" then run the code below, looping.

		if [[ $file != *"/postgres_script.sh" ]]; then
	    source $file #"source" or also represented by "." means to run the code in the file.
		#it doesn't need #!/bin/bash, because it is being called by this program.
		fi 

	done #ends the loop

if true ; then debug2 "wait" ; fi
parmanode_variables $@
debug "waiting"
set_colours #just exports variables with colour settings to make it easier to code with colours
debug2 "after colours"
# Make sure parmanode git directory is not place in $HOME directory, or it will be wiped
# out by the program. Parmanode installs itself (and uninstalls) from $HOME/parmanode.
# Unfortunately, the git name is "parmanode" as well, and the directory name clashes.
# I'll fix this one day.
test_directory_placement #you can go to this funciton and read the code, then come back.

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

debug2 "after update computer"

fix_autoupdate

debug2 "after autoupdate"

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
if [[ -z $lnd_port ]] ; then export lnd_port=9735 ; fi #Line added version 3.14.1

# Check OS function and store in a variable for later. 
# Exits if Windows, or if Mac/Linux not detected.
which_os #use a search function to find functions, eg seach "which_os {". By includding
# the { in your search, you'll narrow down to where the function is defined, and exclude
# the results where it is called on.

which_computer_type


get_ip_address #a function to put the IP address of the computer in memory.

# get version, and suggest user to update if old.

update_version_info 
if [[ $exit_loop == false ]] ; then return 0 ; fi

# set "trap" conditions; currently makes sure user's terminal reverts to default colours
# when they exit.
clean_exit 



check_chip #gets the chip type into config file

	
###### TESTING SECTION #################################################################

debug "Pausing here" #when debugging, I can check for error messages and syntax errors
# before the screen is cleared.

if [[ $1 == chuck ]] ; then export chuck=1 >/dev/null ; fi
if [[ $2 == r ]] ; then export reinstall=1 ; fi
if [[ $1 == user ]] ; then export user=debug ; fi
if [[ $1 == fast ]] ; then export fast=debug ; fi

########################################################################################
debug_fast "test first fast debug" 

motd

# This is the main program, which is a menu that loops.
menu_main zero    

}