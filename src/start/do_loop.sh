function do_loop {

# Deactivate virtual environments that may have been left active from an non-graceful shutdown
deactivate >/dev/null 2>&1

# Test bash version here (but not if its' the first run on a new install)
# Otherwise sourcing will fail if an old bash is used. 
if ! [[ -e "$HOME/.parmanode/.new_install" ]] ; then 
    source "$(find "$HOME/parman_programs/parmanode/src/" -name "*bash_version_test.sh")"
    bash_version_test #exits if test fails (< version 5)
fi

# Source all the modules in /src. Exclude executable scripts which aren't modules. 
# For those learning - Modules are bits of code saved elseshere. They are "sourced" to load the code into memory.

	for file in $HOME/parman_programs/parmanode/src/*/*.sh ; do 
            # For those learning - For every file that ends in .sh, up to one extra directory depth,
            # attach its name to the variable "file" then run the code below, looping so each file gets sourced.
        if [[ -e "$HOME/.parmanode/.new_install" ]] ; then
            source $file 2>/dev/null
        else
            source $file 
            # "source" or also represented by "." means to run the code in the file.
            # Doesn't need #!/bin/bash (or variations) statements inside, because it is being called by this program.  
        fi
	done 


gsed_symlink #linux only

parmanode_variables $@ #CANNOT USE CUSTOM DEBUG FUNCTION BEFORE THIS"
test -f $hm || touch $hm

source_premium

if [[ $parminer == 1 ]] ; then premium=1 ; fi

set_colours #just exports variables with colour settings to make it easier to code with colours
            #parmanode.conf later may override theme

#New installs on Mac are likely to have a white background terminal, so invert colours 
#otherwise it looks bad. Those who use dark mode will still find this aceptable.
if [[ $OS == "Mac" ]] && ! grep -q "colourscheme=" $pc ; then
   change_colours inverted 
fi

debug "printed colours" 
debugfile "test debugfile: ON"
#if [[ $debug == 1 ]] ; then echo -e "${orange}printed colours, hit <enter>" ; read ; fi

test_standard_install
#drive structure
make_home_parmanode 
make_dot_parmanode # NEW INSTALL FLAG ADDED HERE 
parmanode_conf_add # With no argument after the function, this will create a 
                   # parmanode.conf file if it doesnt' exist.
if [[ ! -e $ic ]] ; then touch $ic ; fi
# Load config variables
source $HOME/.parmanode/parmanode.conf >$dn 2>&1 

check_installed_programs

#add to run count
[[ $premium == 1 ]] || rp_counter
test_internet_connected || exit
#btcpayinstallsbitcoin is for a docker container installation initiated by btcpay installation.
[[ $premium == 1 ]] || if [[ $1 != menu ]] ; then
   if [[ $skip_intro != "true" && $btcpayinstallsbitcoin != "true" ]] ; then intro ; instructions ; fi
fi
#If the new_install file exists (created at install) then offer to update computer.
#then delete the file so it doesn't ask again. 
# .new_install created inside a function that creates .parmanode directory for the first time

#test for dependencies and install.
[[ $OS == "Linux" ]] && parmanode_dependencies 

if [[ $btcpayinstallsbitcoin != "true" ]] ; then

    if [[ -e "$HOME/.parmanode/.new_install" ]] ; then
        # If Parmanode has never run before, make sure to get latest version of Parmanode
        cd $HOME/parman_programs/parmanode && git config pull.rebase false >$dn 2>&1 
        git pull >$dn 2>&1 && needs_restart="true" >$dn 2>&1
        update_computer new_install 
        rm $HOME/.parmanode/.new_install
    else
        [[ $premium == 1 ]] || autoupdate
    fi

    if [[ $needs_restart == "true" ]] ; then
    clear
    printf "An update to Parmanode was made to the latest version. Please restart Parmanode
        by typing 'rp' and <enter> at the prompt.\n"
    exit
    fi

fi #end btcpayinstallsbitcoin

#Health check
parmanode1_fix
#prompts every 20 times parmanode is run (reducing load up time of Parmanode)
[[ $premium == 1 ]] || if [[ $rp_count == 1 || $((rp_count % 20 )) == 0 ]] ; then
   #environment checks
   bash_check 
   check_architecture 
fi

########################################################################################
########################################################################################
[[ $premium == 1 ]] || apply_patches
#Add Parmashell (do after patches)
[[ $premium == 1 ]] || install_parmashell 
# get version, and suggest user to update if old.

[[ $btcpayinstallsbitcoin == "true" ]] || update_version_info 
if [[ $exit_loop == "false" ]] ; then return 0 ; fi

# set "trap" conditions; currently makes sure user's terminal reverts to default colours
# when they exit.
clean_exit 

if [[ $enter_cont == "d" ]] ; then unset debug ; fi
# before the screen is cleared.
custom_startup $@
if [[ $btcpayinstallsbitcoin == "true" ]] ; then install_bitcoin ; exit ; fi

#message of the day
[[ $premium == 1 ]] || if [[ $1 != "menu" ]] && [[ ! $debug == 1 ]] ; then
#rossisfree 
#vncishere
########################################################################################
########################################################################################
motd
fi
#Commands that refresh data
pn_tmux "$dp/scripts/update_external_IP2.sh" "checking_external_IP"
test_8333_reachable
jump $1

#
make_parmanode_ssh_keys

recommend_bre_uninstall

# This is the main program, which is a menu that loops.
#Parminer borrows do_loop function, but don't go to parmanode menu
[[ $premium == 1 ]] || menu_main
}
