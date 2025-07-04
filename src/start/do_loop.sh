function do_loop {
clear
#sudo will be needed. Running it early here, getting it out of the way, 
#and it stays in the cache for a while.

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


gsed_symlink 
parmanode_variables $@ #CANNOT USE CUSTOM DEBUG FUNCTION BEFORE THIS"

source_premium

if [[ $parminer == 1 ]] ; then premium=1 ; fi

set_colours #just exports variables with colour settings to make it easier to code with colours
            #parmanode.conf later may override theme
debug "printed colours" "silent"
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
[[ $OS == "Linux" ]] && { parmanode_dependencies || exit ; }

if [[ $btcpayinstallsbitcoin != "true" ]] ; then
if [[ -e $HOME/.parmanode/.new_install ]] ; then
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

if [[ $enter_cont == d ]] ; then unset debug ; fi
# before the screen is cleared.
custom_startup $@
if [[ $btcpayinstallsbitcoin == "true" ]] ; then install_bitcoin ; exit ; fi

#message of the day
[[ $premium == 1 ]] || if [[ $1 != menu ]] && [[ ! $debug == 1 ]] ; then
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

# This is the main program, which is a menu that loops.
#Parminer borrows do_loop function, but don't go to parmanode menu


[[ $premium == 1 ]] || menu_main
}

function check_installed_programs {
if [[ ! -f $ic ]] ; then return 0 ; fi

which gsed >/dev/null 2>&1 || announce "Parmanode cannot detect gsed which is necessary for proper
    functioning. Things aint gonna work right. Be warned."

if ! sudo which nginx >$dn 2>&1 ; then
installed_config_remove "nginx-"
gsed -i '/nginx-/d' $ic
else
installed_config_add "nginx-end"
fi

if { [[ $(uname) == "Darwin" ]] && which docker >$dn       ; } ||
   { [[ $(uname) == "Linux"  ]] && which docker >$dn && id | grep -q docker ; } ; then
       if ! grep -q docker-end $ic ; then
          installed_config_add "docker-end" 
       fi
else 
          installed_config_remove "docker"
fi
}


function parmanode_dependencies {

for i in jq vim unzip tmux ssh tor ufw mdadm gparted ; do

    which $i >$dn || { 

        sudo grep -q "dont_install_$i" $dp/.dont_install && continue

        export needs="needs" ; if [[ $i == gparted ]] ; then export needs="wants" ; fi

        announce "Parmanode $needs to install $i to continue. 
        $green 
        \r$green            y)$orange          OK, do it

        \r$red            n)$orange          Nah, ask me later

        \r$red            nooo)$orange       Nah, never ask again
    "
        case $enter_cont in
            y) [[ $APT_UPDATE == "true" ]] || { sudo apt-get update -y && export APT_UPDATE="true" ; }
                sudo apt install $i -y
                ;;
            nooo) echo "dont_intstall_$i" | tee $dp/.dont_install >$dn 2>&1 ; continue ;;
            *) continue ;;
            esac
    }
done

which nc >$dn || if ! sudo grep -q "dont_install_netcat" $dp/.dont_install ; then

    announce "Parmanode needs to install netcat-tradiational to continue.
        $green 
        \r$green            y)$orange          OK, do it

        \r$red            n)$orange          Nah, ask me later

        \r$red            nooo)$orange       Nah, never ask again (some things won't work)
    "
    case $enter_cont in
            y) [[ $APT_UPDATE == "true" ]] || { sudo apt-get update -y && export APT_UPDATE="true" ; }
                sudo apt install netcat-traditional -y
                ;;
            nooo) echo "dont_intstall_netcat" | tee $dp/.dont_install >$dn 2>&1 ;;
       
    esac
fi

which netstat >$dn || if ! sudo grep -q "dont_install_netstat" $dp/.dont_install ; then

    announce "Parmanode needs to install net-tools to continue.
        $green 
        \r$green            y)$orange          OK, do it

        \r$red            n)$orange          Nah, ask me later

        \r$red            nooo)$orange       Nah, never ask again (some things won't work)
    "
    case $enter_cont in
            y) [[ $APT_UPDATE == "true" ]] || { sudo apt-get update -y && export APT_UPDATE="true" ; }
                sudo apt install net-tools -y
                ;;
            nooo) echo "dont_intstall_net-tools" | tee $dp/.dont_install >$dn 2>&1 ;;
    
    esac
fi   

which notify-send >$dn || if ! sudo grep -q "dont_install_notify-send" $dp/.dont_install ; then

    announce "Parmanode wants to install notify-send to continue.
        $green 
        \r$green            y)$orange          OK, do it

        \r$red            n)$orange          Nah, ask me later

        \r$red            nooo)$orange       Nah, never ask again (not needed as a server only) 
    "
    case $enter_cont in
            y) [[ $APT_UPDATE == "true" ]] || { sudo apt-get update -y && export APT_UPDATE="true" ; }
                sudo apt install libnotify-bin -y
                ;;
            nooo) echo "dont_intstall_notify-send" | tee $dp/.dont_install >$dn 2>&1 ;;
    
    esac
fi 

which tune2fs >$dn || if ! sudo grep -q "dont_install_tune2fs" $dp/.dont_install ; then

    announce "Parmanode wants to install tune2fs/e2fprogs to continue.
        $green 
        \r$green            y)$orange          OK, do it

        \r$red            n)$orange          Nah, ask me later

        \r$red            nooo)$orange       Nah, never ask again 
    "
    case $enter_cont in
            y) [[ $APT_UPDATE == "true" ]] || { sudo apt-get update -y && export APT_UPDATE="true" ; }
                sudo apt install e2fsprogs -y
                ;;
            nooo) echo "dont_intstall_tune2fs" | tee $dp/.dont_install >$dn 2>&1 ;;
 
    esac
fi 

sudo systemctl status ssh >$dn 2>&1 || sudo systemctl start s sh >$dn 2>&1

if ! dpkg -l | grep -q libfuse && ! sudo grep -q "dont_install_libfuse" $dp/.dont_install ; then
[[ $APT_UPDATE == "true" ]] || { sudo apt-get update -y && export APT_UPDATE="true" ; }

    announce "Parmanode needs to install libfuse to continue.
        $green 
        \r$green            y)$orange          OK, do it

        \r$red            n)$orange          Nah, ask me later

        \r$red            nooo)$orange       Nah, never ask again (some things won't work)
    "
    case $enter_cont in
            y) [[ $APT_UPDATE == "true" ]] || { sudo apt-get update -y && export APT_UPDATE="true" ; }
                sudo apt-get install -y fuse3
                sudo apt-get install -y libfuse2
                ;;
            nooo) echo "dont_intstall_libfuse" | tee $dp/.dont_install >$dn 2>&1 ;;
      
    esac
fi   

parmanode_conf_remove "dependency_check1=passed" #remove later
rm $tmp/updateonce 2>$dn
}