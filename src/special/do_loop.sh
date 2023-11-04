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

parmanode_variables $@

set_colours #just exports variables with colour settings to make it easier to code with colours

# Make sure parmanode git directory is not place in $HOME directory, or it will be wiped
# out by the program. Parmanode installs itself (and uninstalls) from $HOME/parmanode.
# Unfortunately, the git name is "parmanode" as well, and the directory name clashes.
# I'll fix this one day.
test_directory_placement #you can go to this funciton and read the code, then come back.
debug "before install_parmanode"
install_parmanode

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