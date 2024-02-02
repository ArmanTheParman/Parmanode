function do_loop {
#Educational comments included.

#The first line, including the # is treated specially. It means this is
#a script, and invokes the bash program to run it. It must be the very first
#character in a file followed by !, then the path to the terminal program.


#check script is being run from parmanode directory so relative paths work
#-f checks if a file exists in the working directory. If it doesn't, it 
#means the run_parmanode.sh file is not in the correct location.

source $HOME/parman_programs/parmanode/src/patches/safetypatch.sh >/dev/null 2>&1
#optional emergency patches in case an update breaks the program and updates
#can't be made to fix. By de
#safetypatch1
#safetypatch2

if [ -f do_not_delete_move_rename.txt ] ; then true ; else
clear
echo "
The run_parmanode.sh script must be run from it's original directory. It
cannot be moved relative to all the other files, but it can be run
by calling it with a different script from elsewhere.

Exiting. 

Hit <enter> to exit."
read #this command takes any user keyboard input, waiting for <enter> to continue.
exit 0
fi

# source all the modules. Exclude executable scripts which aren't modules. Modules
# are bits of codes saved elseshere. They are "sourced" to load the code into memory.

	for file in ./src/**/*.sh ; do #for every file that ends in .sh, up to a directory
	#length of 1, attach its name to the variable "file" then run the code below, 
	#looping so each file gets sourced.

		if [[ $file != *"/postgres_script.sh" ]]; then #The if statement excludes one file
	    source $file #"source" or also represented by "." means to run the code in the file.
		#They doesn't need #!/bin/bash (or variations) statements inside, because it is being called by 
		# this program.  
		fi 

	done #ends the loop

parmanode_variables $@ #CANNOT USE CUSTOM DEBUG FUNCTION BEFORE THIS"

set_colours #just exports variables with colour settings to make it easier to code with colours
            #parmanode.conf later may override theme

if [[ $debug == 1 ]] ; then echo -e "${orange}printed colours, hit <enter>" ; read ; fi

# Makes sure parmanode git directory is not place in $HOME directory, or it will be wiped
# out by the program. Parmanode installs itself (and uninstalls) from $HOME/parmanode.
# Unfortunately, the git name is "parmanode" as well, and the directory name clashes.
# I'll fix this one day.
test_directory_placement #you can go to this funciton and read the code, then come back.

set_terminal

#drive structure
make_home_parmanode 
make_dot_parmanode # NEW INSTALL FLAG ADDED HERE 
parmanode_conf_add # With no argument after the function, this will create a 
                   # parmanode.conf file if it doesnt' exist.
if [[ ! -e $HOME/.parmanode/installed.conf ]] ; then touch $HOME/.parmanode/installed.conf ; fi

# Load config variables
source $HOME/.parmanode/parmanode.conf >/dev/null 2>&1 

# If docker is set up on the machine, then it is detected by Parmanode
# and added to the config file
# The block of code is added to the background to not delay start up
if [[ -f $HOME/.parmanode/installed.conf ]] ; then #execute only if an installed config file exits otherwise not point.
	if ([[ $(uname) == Darwin ]] && ( which docker >/dev/null )) || \
	( [[ $(uname) == Linux ]] && which docker >/dev/null && id | grep -q docker ) ; then
		if ! grep -q docker-end < $HOME/.parmanode/installed.conf ; then
			installed_config_add "docker-end" 
		fi
	else installed_config_remove "docker"
	fi
fi

#add to run count
rp_counter


########################################################################################
#Intro
########################################################################################
set_terminal # custom function for screen size and colour.
# argument "m" sets skip_intro to true in parman_variables
if [[ $skip_intro != "true" ]] ; then intro ; instructions ; fi


#If the new_install file exists (created at install) then offer to update computer.
#then delete the file so it doesn't ask again. 
if [[ -e $HOME/.parmanode/.new_install ]] ; then
update_computer 
rm $HOME/.parmanode/.new_install
else
[ $debug = menu ] || autoupdate
fi

#Health check
parmanode1_fix

#prompts every 20 times parmanode is run (reducing load up time of Parmanode)
if [[ $rp_count == 1 || $((rp_count % 20 )) == 0 ]] ; then
   #environment checks
   bash_check 
   ensure_english
   check_architecture 
   #commit config directory state using git
   git_dp &
fi

apply_patches  

# get version, and suggest user to update if old.

update_version_info 
if [[ $exit_loop == false ]] ; then return 0 ; fi

# set "trap" conditions; currently makes sure user's terminal reverts to default colours
# when they exit.
clean_exit 

	
###### TESTING SECTION #################################################################

debug "Pausing here. IP: $IP" #when debugging, I can check for error messages and syntax errors
# before the screen is cleared.

if [[ $test == true ]] ; then
export debug=true
measure_rpc_global
debug "after measure rpc global"
fi

########################################################################################

#message of the day
[ $debug = menu ] || motd

# This is the main program, which is a menu that loops.
menu_main

}
