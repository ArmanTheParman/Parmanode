#!/bin/bash

if [[ "$1" == "debug" || $1 == "debug=1" ]] ; then debug=1 ; else debug=0 ; fi

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

if [[ $debug == 1 ]] ; then debug1 "Pause here to check for error output before clear screen." ; fi

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
	#menu_main

exit 0
