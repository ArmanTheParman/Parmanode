#!/bin/bash

#Educational comments included.

#The first line, including the # is treated specially. It means this is
#a script, and invokes the bash program to run it. It must be the very first
#character in a file followed by !, then the path to the terminal program.

#The following code checks if in debugging mode. Mainly for developing, not client usage
#If debug is 1, then a debuging function becomes active, which pauses the
#program wherever it appears. "export" keeps variable in global memory.
if [[ $1 == "debug" || $1 == d ]] ; then export debug=1 
elif [[ $1 == "debug2" || $1 == d2 ]] ; then export debug=2  
else export debug=0 
fi

if [[ $1 == "usertest" ]] ; then export ut=1 ; fi

#save position of working directory. "Export" makes the variable available everywhere.
export original_dir=$(pwd) >/dev/null 2>&1

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

# Config directory needs to be made
if [[ ! -d $HOME/.parmanode ]] ; then
mkdir -p $HOME/.parmanode >/dev/null 2>&1  
fi
#2>&1 means if there is a standard error output (2), 
# send it to standard output (1), which is, in this case, to /dev/null.

set_colours #just exports variables with colour settings to make it easier to code with colours

# Make sure parmanode git directory is not place in $HOME directory, or it will be wiped
# out by the program. Parmanode installs itself (and uninstalls) from $HOME/parmanode.
# Unfortunately, the git name is "parmanode" as well, and the directory name clashes.
# I'll fix this one day.
test_directory_placement #you can go to this funciton and read the code, then come back.

# Check OS function and store in a variable for later. 
# Exits if Windows, or if Mac/Linux not detected.
which_os #use a search function to find functions, eg seach "which_os {". By includding
# the { in your search, you'll narrow down to where the function is defined, and exclude
# the results where it is called on.

which_computer_type


get_ip_address #a function to put the IP address of the computer in memory.

# get version, and suggest user to update if old.
update_version_info 

# set "trap" conditions; currently makes sure user's terminal reverts to default colours
# when they exit.
clean_exit 

# With no argument after the function, this will create a parmanode.conf file if it doesnt' exist.
parmanode_conf_add

# Make parmanode config file if it doesn't exist
if [[ ! -f $HOME/.parmanode/parmanode.conf ]] ; then 
	touch $HOME/.parmanode/parmanode.conf >/dev/null
	debug "touch parmanode.conf"
	fi

# Load config variables
source $HOME/.parmanode/parmanode.conf >/dev/null 2>&1 

#if docker is set up on the machine, then it is detected by Parmanode
#and added to the config file
if [[ -f $HOME/.parmanode/installed.conf ]] ; then #execute only if an installed config file exits otherwise not point.
	if id | grep -q docker && which docker >/dev/null ; then
		if ! grep -q docker-end < $HOME/.parmanode/installed.conf ; then
			installed_config_add "docker-end" 
		fi
	fi
fi

# fix fstab for older parmanode versions. This is a bug fix which will soon be obsolete.
# In older versions there was a field missing in fstab which caused a system crash if
# the drive was physically disconnected during a reboot.
fix_fstab ; fix_lnd_service

debug "Pausing here" #when debugging, I can check for error messages and syntax errors
# before the screen is cleared.

# This sends a dummy https request to a non-existant file which triggers a counter on the server.
curl -s https://parman.org/parmanode_${version}_run_parmanode_counter >/dev/null 2>&1 &

# Set variables
    Linux_distro #gets the linux distro into a config file
    check_chip #gets the chip type into config file

#autoupdate question
    if grep -q parmanode-end < $HOME/.parmanode/installed.conf ; then autoupdate ; fi	
	
#Begin program:
	set_terminal # custom function for screen size and colour.
	if [[ $skip_intro != "true" ]] ; then intro ; instructions ; fi

	# This is the main program, which is a menu that loops.
	menu_main    

exit 0
