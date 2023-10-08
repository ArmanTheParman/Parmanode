return 0
########################################################################################
# This file is to be kept at parmanode.com.
# The install script will download it to the desktop and make it executable.
# https://parmanode.com/umbrel_import.sh
########################################################################################

#!/bin/bash

# Debug toggle

    if [[ $1 == d ]] ; then export debug=1 ; else export debug=0; fi

# Variables 
    

# Size 88 wide, and orange colour scheme

    printf '\033[8;38;88t' && echo -e "\033[38;2;255;145;0m" 

# Intro

   clear ; echo "
########################################################################################

   
              P A R M A N O D E - Umbrel drive import tool for Macs.

    This script will use Parmanode software to take an Umbrel external hard drive 
    (Linux) and use a Mac to convert it so that it can be used with a Linux machine 
    running Parmanode.

    A simpler approach is to use that Linux machine running Parmanode to convert the
    drive, using tools available in Parmanode software, but there this is anyway...

########################################################################################
Hit <enter> to continue, <control>-c to quit.
"
read choice ; clear

clear ; echo "
########################################################################################

                       P  A  R  M  A  N  O  D  L     O  S 


    The target microSD can be as small as 16GB.

    The entire process may take about 30 minutes to 1 hour depending on the speed of
    the computer. There will be ocassional promtps/quesions so keep an eye out.

    You'll also be asked to remove/insert the microSD card to assist with drive 
    detection.

    For best probability of success, do not do resource intensive things while the
    computer is thinking. 

########################################################################################

    Hit <enter> to continue
    " ; read
    
    if [[ $(uname) == Darwin ]] ; then clear ; echo "
########################################################################################


    There are a few extra things that may need to be 
    installed if you don't have it ...

        1)    Docker     -     This is a tricky installation to execute in an
                               automated way. If the installation fails at the 
                               Docker install, you could try to install it yourself, 
                               then come back to this. The installation will be 
                               detected. Docker is needed because the file system 
                               that Umbrel is built from is Linux based and needs 
                               to be mounted. Docker can give us a little temporary
                               Linux container to work with. You can uninstall it
                               later if you want.
       

########################################################################################

       Hit <enter> to continue
"
read ; clear ; echo "
########################################################################################


        2)    Homebrew   -     This is a package manager for Mac. It allows installtion
                               of programs using the command line only - pretty cool,
                               and necessary for this to work. If installation is
                               needed, it will be taken care of, but does add possibly
                               5 to 10 minutes extra to the whole process.
        
        3)   Bits and 
             bobs        -     A few little tools here an there may also be added to
                               make the installation go smotther, it won't affect your
                               system in any negative way.
    
########################################################################################

       Hit <enter> to continue

"
read 
fi
echo "
Please wait...
"

# Detect the OS

    if [[ $(uname) == Linux ]] ; then export OS=Linux ; fi
    if [[ $(uname) == Darwin ]] ; then export OS=Mac ; fi

# Detect the Machine

    if [[ $OS == Mac ]] ; then export machine=Mac ; fi
    if [[ $OS == Linux ]] ; then
        if sudo cat /proc/cpuinfo | grep "Raspberry Pi" ; then export machine=Pi ; fi
    fi
    if [[ $machine != Mac && $machine != Pi ]] ; then export macine=other ; fi

# Detect the chip

    export chip=$(uname -m)

#need to get part 1 dependencies

    if [[ $OS = Mac ]] ; then 

        if ! which brew >/dev/null ; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 
        if ! which brew >/dev/null ; then export warning=1 ; fi
        fi

        if ! which greadlink >/dev/null ; then
            if [[ $warning == 1 ]] ; then echo "problem with homebrew, needed to install coreutils/greadlink. Aborting." ; sleep 4 ; exit ; fi
            brew install coreutils
        fi

        if ! which git >/dev/null ; then
            if [[ $warning == 1 ]] ; then echo "problem with homebrew, needed to install git. Aborting." ; sleep 4 ; exit ; fi
            brew install git
        fi

        if ! which ssh >/dev/null ; then 
            if [[ $warning == 1 ]] ; then echo "problem with homebrew, needed to install git. Aborting." ; sleep 4 ; exit ; fi
            brew install ssh 
        fi

        if ! which gpg >/dev/null ; then 
            if [[ $warning == 1 ]] ; then echo "problem with homebrew, needed to install git. Aborting." ; sleep 4 ; exit ; fi
            brew install gpg 
        fi
    
    fi

    if [[ $OS == Linux ]] ; then
        
        sudo apt-get update -y
        if ! which vim ; then sudo apt-get install vim -y ; fi
        if ! which git ; then sudo apt-get install git -y ; fi
        if ! which ssh ; then sudo apt-get install ssh -y ; fi

    fi


# Get Parmanode or update

   if [ ! -e ~/parman_programs/parmanode/src ] ; then
        mkdir -p ~/parman_programs
        cd ~/parman_programs
        git clone --depth 1 https://github.com/armantheparman/parmanode.git || \
          { announce "Unable to get parmanode scripts with git. Aborting." ; exit 1 ; }
    else
        cd $HOME/parman_programs/parmanode/
        git pull >/dev/null
    fi

# Source Parmanode & ParmanodL scripts to get needed functions

    for file in ~/parman_programs/parmanode/src/**/*.sh ; do 
		if [[ $file != *"/postgres_script.sh" ]]; then
	    source $file 
        fi 
    done

# Now that parmanode scripts have been sourced, the code from here on can be tidier, 
# as Parmanode functions are available.

# Part 2 dependencies - Macs need Docker

    Macs_need_docker || exit

# Make necessary directories

    ParmanodL_directories ;  log "parmanodl" "directory function"


#GET UMBREL DISK ID...
    
    detect_drive umbrelmac


# Macs use Docker functionality here
    
    ParmanodL_docker_run || { log "parmanodl" "failed at docker_run" ; exit ; }
    ParmanodL_docker_get_binaries || { log "parmanodl" "failed at docker_get_binaries" ; exit ; }
    
# Mount the image and dependent directories

    ParmanodL_mount || { log "parmanodl" "failed at ParmanodL_mount" ; exit ; }

# Modify the image with chroot

    ParmanodL_chroot ; log "parmanodl" "finished ParmanodL_chroot"

# Debug - opportunity to pause and check

    debug "Chroot finished. Pause to check."

# Unmount the image and system directories

    ParmanodL_unmount ; log "parmanodl" "finished ParmanodL_unmount"

# Get microSD device name into disk variable - user input here

    detect_microSD || { log "parmanodl" "failed at detect_microSD" ; exit ; }

# Write the image to microSD

    ParmanodL_write || { log "parmanodl" "failed at ParmanodL_write" ; exit ; }

# Clean known hosts of parmanodl
 
    clean_known_hosts ; log "parmanodl" "finished clean_known_hosts"

# make run_parmanodl for desktop execution

    make_Run_ParmanodL ; log "parmanodl" "finished make_run_parmanodL"

# Remove temporary script

    rm $HOME/Desktop/ParmanodL_Installer && log "parmanodl" "installer removed"
    
# Clean up the mess

    ParmanodL_cleanup

# Success output

    ParmanodL_success

# The End
