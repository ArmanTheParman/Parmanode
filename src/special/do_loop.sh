function do_loop {
clear
#sudo will be needed. Running it early here, getting it out of the way, 
#and it stays in the cache for a while.
if ! echo $@ | grep -q "np" ; then
sudo true ;
fi
#deactivate virtual environments that may have been left active from an non-graceful shutdown
deactivate >/dev/null 2>&1
#check script is being run from parmanode directory so relative paths work
#-f checks if a file exists in the working directory. If it doesn't, it 
#means the run_parmanode.sh file is not in the correct location.

# source all the modules. Exclude executable scripts which aren't modules. Modules
# are bits of codes saved elseshere. They are "sourced" to load the code into memory.

	for file in $HOME/parman_programs/parmanode/src/*/*.sh ; do #for every file that ends in .sh, up to a directory
	#length of 1, attach its name to the variable "file" then run the code below, 
	#looping so each file gets sourced.
	    source $file #"source" or also represented by "." means to run the code in the file.
		#They doesn't need #!/bin/bash (or variations) statements inside, because it is being called by 
		# this program.  
	done #ends the loop


    [[ -e $HOME/parman_programs/parmaweb ]] && for file in $HOME/parman_programs/parmaweb/src/*.sh ; do
	    source $file
	done
    [[ -e $HOME/parman_programs/parminer ]] && for file in $HOME/parman_programs/parminer/src/*.sh ; do
	    source $file
	done


gsed_symlink 
parmanode_variables $@ #CANNOT USE CUSTOM DEBUG FUNCTION BEFORE THIS"

set_colours #just exports variables with colour settings to make it easier to code with colours
            #parmanode.conf later may override theme
debug "printed colours" "silent"
#if [[ $debug == 1 ]] ; then echo -e "${orange}printed colours, hit <enter>" ; read ; fi

test_standard_install

set_terminal

#drive structure
make_home_parmanode 
make_dot_parmanode # NEW INSTALL FLAG ADDED HERE 
parmanode_conf_add # With no argument after the function, this will create a 
                   # parmanode.conf file if it doesnt' exist.
if [[ ! -e $ic ]] ; then touch $ic ; fi

# Load config variables
source $HOME/.parmanode/parmanode.conf >$dn 2>&1 

# If docker is set up on the machine, then it is detected by Parmanode
# and added to the config file
if [[ -f $ic ]] ; then #execute only if an installed config file exits otherwise not point.
	if ([[ $(uname) == Darwin ]] && ( which docker >$dn )) || \
	( [[ $(uname) == Linux ]] && which docker >$dn && id | grep -q docker ) ; then
		if ! grep -q docker-end $ic ; then
			installed_config_add "docker-end" 
		fi
	else installed_config_remove "docker"
	fi
fi
#add to run count
rp_counter
test_internet_connected || exit
########################################################################################
#Intro
########################################################################################
set_terminal # custom function for screen size and colour.
# argument "m" sets skip_intro to true in parman_variables

#btcpayinstallsbitcoin is for a docker container installation initiated by btcpay installation.
if [[ $1 != menu ]] ; then
   if [[ $skip_intro != "true" && $btcpayinstallsbitcoin != "true" ]] ; then intro ; instructions ; fi
fi

#If the new_install file exists (created at install) then offer to update computer.
#then delete the file so it doesn't ask again. 
# .new_install created inside a function that creates .parmanode directory for the first time
if [[ $btcpayinstallsbitcoin != "true" ]] ; then
if [[ -e $HOME/.parmanode/.new_install ]] ; then

	# If Parmanode has never run before, make sure to get latest version of Parmanode
	cd $HOME/parman_programs/parmanode && git config pull.rebase false >$dn 2>&1 
	git pull >$dn 2>&1 && needs_restart="true" >$dn 2>&1

	update_computer new_install 
	rm $HOME/.parmanode/.new_install
else
	autoupdate
fi

if [[ $needs_restart == "true" ]] ; then
announce "An update to Parmanode was made to the latest version. Please restart Parmanode."
exit
fi
fi #end btcpayinstallsbitcoin
#Health check
parmanode1_fix
#prompts every 20 times parmanode is run (reducing load up time of Parmanode)
if [[ $rp_count == 1 || $((rp_count % 20 )) == 0 ]] ; then
   #environment checks
   bash_check 
   check_architecture 
fi
apply_patches
#Add Parmashell (do after patches)
install_parmashell 

# get version, and suggest user to update if old.

[[ $btcpayinstallsbitcoin == "true" ]] || update_version_info 

if [[ $exit_loop == "false" ]] ; then return 0 ; fi

# set "trap" conditions; currently makes sure user's terminal reverts to default colours
# when they exit.
clean_exit 

if [[ $enter_cont == d ]] ; then unset debug ; fi
# before the screen is cleared.
custom_startup $@
if [[ $btcpayinstallsbitcoin == "true" ]] ; then install_bitcoin ; exit ; fi

#message of the day
if [[ $1 != menu ]] && [[ ! $debug == 1 ]] ; then
rossisfree 
motd
fi

#Commands that refresh data
pn_tmux "$dp/update_external_IP2.sh" "checking_external_IP"
test_8333_reachable

jump $1
# This is the main program, which is a menu that loops.

if [[ $parminer != 1 ]] ; then #Parminer borrows do_loop function, but don't go to parmanode menu
menu_main
fi

}
