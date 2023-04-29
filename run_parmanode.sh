#!/bin/bash
original_dir=$(pwd) >/dev/null 2>&1

if [[ ! $(basename $(pwd)) == "parmanode" ]] >/dev/null ; then
clear
echo "The Parmanode script must be run while your working directory is the
Parmanode directory where the file lives. Running the file from outside
the directory will cause the functions of the program to faile. Exiting.
Hit <enter> to exit."
read
exit 0
fi


# source all the  modules.

	for file in ./src/**/*.sh
	do
	source $file
	done

test_directory_placement
debug

# Check OS function and store in variable for later. Exits if Windows, or if not if Mac/Linux not detected.

	which_os

# set "trap" conditions; currently makes sure user's terminal reverts to default colours.

	clean_exit 

# Debug - comment out before release.

  #   debug "Pause here to check for error output before clear screen." 


# Load config 

    source $HOME/.parmanode/parmanode.conf	>/dev/null 2>&1

#Begin program:

	set_terminal # custom function for screen size and colour.
	intro
	startup

exit 0
