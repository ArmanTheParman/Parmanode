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


    source $HOME/.parmanode/parmanode.conf	>/dev/null 2>&1exit 0

	"$1"

enter_continue
