#!/bin/bash

which_os

source $HOME/.parmanode/parmanode.conf	>/dev/null 2>&1

if [[ $1 == "debug" || "$1" == "debug=1" ]] ; then debug=1 ; else debug=0 ; fi


# source all the modules. Exclude executable scripts

	for file in ./src/**/*.sh ; do

		if [[ $file != *"/postgres_script.sh" ]]; then
	    source $file
		fi 

	done


"$1"

exit 0
