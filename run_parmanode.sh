#!/bin/bash

#check if in debugging mode
if [[ $1 == "debug" || "$1" == "debug=1" ]] ; then export debug=1 ; else export debug=0 ; fi

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
if [[ $OS == "Linux" ]] ; then IP=$( ip a | grep "inet " | grep -v 127.0.0.1 | grep -v 172.1 | awk '{print $2}' | cut -d '/' -f 1 | head -n1 ) ; fi
if [[ $OS == "Mac" ]] ; then IP=$( ifconfig | grep "inet " | grep -v 127.0.0.1 | grep -v 172.1 | awk '{print $2}' | head -n1 ) ; fi

# get version
source ./version.conf

# set "trap" conditions; currently makes sure user's terminal reverts to default colours.

	clean_exit 
	
# Config directory needs to be made
mkdir $HOME/.parmanode >/dev/null 2>&1 
# Empty parmanode.conf file if it doesnt' exist
parmanode_conf_add

# Load config 
if [[ -f $HOME/.parmanode/parmanode.conf ]] ; then source $HOME/.parmanode/parmanode.conf >/dev/null 2>&1 ; fi

#OPTIONALITY:
while true ; do

# Continue if user left unfinished
if [[ -f $HOME/.parmanode/installed.conf ]] ; then

 	if cat $HOME/.parmanode/installed.conf | grep "btcpay-half" ; then
	install_btcpay_linux "resume"
	skip_intro="true"
	break
	fi

	if cat $HOME/.parmanode/parmanode.conf | grep "dockerexitbtcpay=1" ; then
	export dokerexitbtcpay=1
	install_btcpay_linux || { skip_intro="false" ; break ; }
	skip_intro="true"
	break
	fi

 	if cat $HOME/.parmanode/installed.conf | grep "mempool-half" ; then
	install_mempool "resume"
	skip_intro="true"
	break
	fi

 	if cat $HOME/.parmanode/parmanode.conf | grep "dockerexitmem=1" ; then
	export dockerexitmem=1
	install_mempool "resume" || { skip_intro="false" ; break ; }
	skip_intro="true"
	break
	fi
fi

break ; done

#fix fstab for older parmanode versions
fix_fstab

if [[ $1 == "debug2" ]] ; then

delete_line "/etc/tor/torrc" "bitcoin-service"

enter_continue
exit

fi
debug1 "Pausing here"

curl https://parman.org/downloadable/parmanode_run.html >/dev/null 2>&1 &

#Begin program:
	set_terminal # custom function for screen size and colour.
	if [[ $skip_intro != "true" ]] ; then intro ; instructions ; fi
	menu_main    


exit 0
