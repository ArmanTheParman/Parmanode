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

    You'll also be asked to remove/insert the Umbrel drive to assist with drive 
    detection.
$cyan
            MAKE SURE TO BEGIN WITH, THE UMBREL DRIVE IS NOT CONNECTED.
   $orange 
########################################################################################

    Hit <enter> to continue
    " ; read
    
    if [[ $(uname) == Darwin ]] ; then clear ; echo "
########################################################################################


    There are a few extra things that may need to be 
    installed if you don't have it ...

        1)    Docker     -     Needed because the file system that Umbrel is built 
                               from is Linux based and it needs to be mounted. 
                               Docker can give us a little temporary Linux container 
                               to work with. You can uninstall it later if you want.
       

########################################################################################

       Hit <enter> to continue
"
read ; clear ; echo "
########################################################################################


        2)    Homebrew   -     This is a package manager for Mac. It allows installtion
                               of programs using the command line only - pretty cool,
                               and necessary for this to work. If installation is
                               needed, it will be taken care of, but does take possibly
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
    
    detect_drive menu umbrelmac


# Macs use Docker functionality here
    
    ParmanodL_docker_run || { log "parmanodl" "failed at docker_run" ; exit ; }
    ParmanodL_docker_get_binaries || { log "parmanodl" "failed at docker_get_binaries" ; exit ; }
    
# Template from umbrel_import.sh 
########################################################################################################################
cd
set_terminal ; echo -e "
########################################################################################
$cyan
                             UMBREL DRIVE IMPORT TOOL
$orange
    This program will convert your Umbrel external drive to make it compatible with
    Parmanode, preserving any Bitcoin block data that you may have already sync'd up.

    Simply use this convert tool, and plug into any Parmanode computer (ParmanodL). 
    I say \"any\", but do know that if it's another ParmanodL, you still need to 
    \"import\" the drive on that computer as well - there is a \"Import to Parmnaode\"
    option in the tools menu.

    If you wish to go back to Umbrel, then use the \"Revert to Umbrel\" tool, otherwise
    the drive won't work properly.

########################################################################################
"
choose "eq" ; read choice
case $choice in q|Q|P|p) return 1 ;; *) true ;; esac

while sudo mount | grep -q parmanode ; do 
set_terminal ; echo -e "
########################################################################################
    
    This function will$cyan refuse to run$orange if it detects an existing mounted 
    or even connected Parmanode drive. Bad things can happen. 

    If you want to continue, make sure any programs syncing to the drive (Bitcoin, or
    Fulcrum) have been stopped, then$pink unmount$orange the drive, then disconnect it,
    then come back to this function.

    Or, do you want Parmanode to attempt to cleanly stop everything and unmount the 
    drive for you?

               y)       Yes please, how kind.

               nah)     Nah ( = \"No\" in Straylian)

########################################################################################
"
choose "xpq" ; read choice ; set_terminal
case $choice in
p|P|nah|No|Nah|NAH|NO|n|N) return 1 ;;
q|Q) exit ;; 
y|Y|Yes|yes|YES)
safe_unmount_parmanode || return 1 
;;
*) invalid ;;
esac
done

while sudo blkid | grep -q parmanode ; do
set_terminal ; echo -e "
########################################################################################

            Please disconnect any Parmanode drive from the computer.

            Hit a and then <enter> to abort.

            Hit <enter> once disconnected.

########################################################################################
"
read choice
case $choice in a|A) return 1 ;; esac
done

while ! sudo lsblk -o LABEL | grep -q umbrel ; do
debug "2a"
set_terminal ; echo -e "
########################################################################################

    Please insert the Umbrel drive you wish to import, then hit$cyan <enter>.$orange

########################################################################################
"
read ; set_terminal ; sync
done


#Get disk ID