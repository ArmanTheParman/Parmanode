#!/bin/bash

#check if in debugging mode
if [[ $1 == "debug" || "$1" == "debug=1" ]] ; then debug=1 ; else debug=0 ; fi

#save position of working directory
original_dir=$(pwd) >/dev/null 2>&1

#check script is being run from parmanode directory so relative paths work
if [[ -f do_not_delete_move_rename.txt ]] ; then true ; else
clear
echo "
The run_parmanode.sh script must be run from it's original directory. It
cannot be moved relative to all the other files, nor can it be run
by calling it from a different direcory.

Exiting. Hit <enter> to exit."
read
exit 0
fi

# source all the modules. Exclude executable scripts

	for file in ./src/**/*.sh ; do

		if [[ $file != *"/postgres_script.sh" ]]; then
	    source $file
		fi 

	done

# Make sure parmanode git directory is not place in $HOME directory, or it will be wipe 
# out by the program
test_directory_placement

# Check OS function and store in variable for later. Exits if Windows, or if not if Mac/Linux not detected.

	which_os

# get IP address
if [[ $OS == "Linux" ]] ; then IP=$( ip a | grep "inet " | grep -v 127.0.0.1 | grep -v 172.1 | awk '{print $2}' | cut -d '/' -f 1 ) ; fi
if [[ $OS == "Mac" ]] ; then IP=$( ifconfig | grep "inet " | grep -v 127.0.0.1 | grep -v 172.1 | awk '{print $2}' ) ; fi

# get version
source ./src/config/version.conf

# set "trap" conditions; currently makes sure user's terminal reverts to default colours.

	clean_exit 
	
# Config directory needs to be made
mkdir $HOME/.parmanode >/dev/null 2>&1 
debug1 "Pause here to check for error output before clear screen." 

# Load config 
source $HOME/.parmanode/parmanode.conf	>/dev/null 2>&1

#OPTIONALITY:
while true ; do

# Continue if user left unfinished
 	if cat $HOME/.parmanode/installed.conf | grep "btcpay-half" ; then
	install_btcpay_linux "resume"
	skip_intro="true"
	break
	fi

break ; done

#Begin program:
	set_terminal # custom function for screen size and colour.
	if [[ $skip_intro != "true" ]] ; then intro ; fi
	instructions
	menu_main    


exit 0
