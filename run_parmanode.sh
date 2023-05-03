#!/bin/bash

if [[ $1 == "debug" || "$1" == "debug=1" ]] ; then debug=1 ; else debug=0 ; fi

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


# source all the modules. Exclude executable scripts

	for file in ./src/**/*.sh ; do

		if [[ $file != *"/postgres_script.sh" ]]; then
	    source $file
		fi 

	done

test_directory_placement

# Check OS function and store in variable for later. Exits if Windows, or if not if Mac/Linux not detected.

	which_os

# get IP address
IP=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | grep -v 172.1 | awk '{print $2}')

# set "trap" conditions; currently makes sure user's terminal reverts to default colours.

	clean_exit 

# Config directory needs to be made
mkdir $HOME/.parmanode >/dev/null 
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
