#!/bin/bash
    original_dir=$(pwd)
	
# source all the modules. Exclude executable scripts

	for file in ./src/**/*.sh ; do

		if [[ $file != *"/postgres_script.sh" ]]; then
	    source $file
		fi 

	done


# Check OS function and store in variable for later. Exits if Windows, or if not if Mac/Linux not detected.

	which_os

# set "trap" conditions; currently makes sure user's terminal reverts to default colours.

	clean_exit 

# Debug - comment out before release.

     debug "Pause here to check for error output before clear screen." 

# Load config 

    source $HOME/.parmanode/parmanode.conf	>/dev/null 2>&1

# Continue if user left unfinished
	if cat $HOME/.parmanode/installed.conf | grep "btcpay-half" ; then
          install_btcpay_linux "resume"
		  fi
#Begin program:

	set_terminal # custom function for screen size and colour.
	intro
	menu_main

exit 0
