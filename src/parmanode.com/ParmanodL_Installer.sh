function parmanodl_installer {
if [[ $1 != install ]] ; then return 0 ; fi
########################################################################################
# The contents of this file is to be kept at parmanode.com. It is not meant to have a
# .sh extension
# The install script will download it to the desktop and make it executable.
########################################################################################

#!/bin/bash

#get parmanode function
# cd /tmp
# curl -LO https://parmanode.com/parmanode.tar
# tar -xvf parmanode.tar
# rm parmanode.tar
# for file in /tmp/parmanode/src/text_functions/*.sh ; do
#     source $file
# done


# Version specific info
    
    export zip_file="2023-05-03-raspios-bullseye-arm64.img.xz"
    export zip_path="$HOME/ParmanodL/$zip_file"
    export image_file="2023-05-03-raspios-bullseye-arm64.img"
    export image_path="$HOME/ParmanodL/$image_file" 
    export hash_zip="e7c0c89db32d457298fbe93195e9d11e3e6b4eb9e0683a7beb1598ea39a0a7aa"
    export hash_image="962780be6bb41522532f26449f67524dc61038673833c079808da9ca2ad9a4f0"

# Size 88 wide, and orange colour scheme

    printf '\033[8;38;88t' && echo -e "\033[38;2;255;145;0m" 

# Intro

while true ; do

   if [[ $1 == install ]] ; then break ; fi

   clear ; echo -e "$orange
########################################################################################

  $cyan 
                       P  A  R  M  A  N  O  D  L     O  S 
$orange

   This software will help you install Parmanodl OS onto an external drive or 
   micro SD card which you can then use to install the OS onto a Pi4 computer. 

   Yes, strictly speaking, ParmanodL isn't its own OS, but when you write code, you
   can do whatever you want, including giving your software cool sounding names :P


########################################################################################
Hit <enter> to continue
"
read ; clear

break ; done


clear ; echo -e "$orange
########################################################################################
$cyan
                       P  A  R  M  A  N  O  D  L     O  S 
$orange

    The entire process may take about 30 minutes to 1 hour depending on the speed of
    the computer. There will be ocassional promtps/quesions so keep an eye out.

    You'll also be asked to remove/insert the microSD card (minimum 16GB) to assist 
    with drive detection.

    For best probability of success, do not do resource intensive things while the
    computer is thinking. 

########################################################################################

    Hit <enter> to continue
    " ; read
    
    if [[ $(uname) == Darwin && $1 != install ]] ; then clear ; echo "
########################################################################################


    Becuase you're using a Mac, there are a few extra things that may need to be 
    installed...


        1)    Docker     -     Docker is needed because the Pi OS image that ParmanodL 
                               is build from is Linux based and needs to be mounted. 
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

if [[ $1 != install ]] ; then

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

        if ! which git >/dev/null ; then
            if [[ $warning == 1 ]] ; then echo "problem with homebrew, needed to install git. Aborting." ; sleep 4 ; exit ; fi
            brew install git
        fi

        if ! which ssh >/dev/null ; then 
            if [[ $warning == 1 ]] ; then echo "problem with homebrew, needed to install ssh. Aborting." ; sleep 4 ; exit ; fi
            brew install ssh 
        fi

        if ! which gpg >/dev/null ; then 
            if [[ $warning == 1 ]] ; then echo "problem with homebrew, needed to install gpg. Aborting." ; sleep 4 ; exit ; fi
            brew install gpg 
        fi

	    if ! which xz >/dev/null ; then
            if [[ $warning == 1 ]] ; then echo "problem with homebrew, needed to install xz. Aborting." ; sleep 4 ; exit ; fi
            brew install xz
        fi

        if ! which jq >/dev/null ; then
            if [[ $warning == 1 ]] ; then echo "problem with homebrew, needed to install jq. Aborting." ; sleep 4 ; exit ; fi
            brew install jq
        fi
    
    fi

    if [[ $OS == Linux ]] ; then
        
        sudo apt-get update -y
        if ! which vim ; then sudo apt-get install vim -y ; fi
        if ! which git ; then sudo apt-get install git -y ; fi
        if ! which ssh ; then sudo apt-get install ssh -y ; fi
        if ! which xz-utils  ; then sudo apt-get install xz-utils -y ; fi
        if ! command -v jq &> /dev/null; then sudo apt-get install jq ; fi

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

fi # end if $1 != install

# Now that parmanode scripts have been sourced, the code from here on can be tidier, 
# as Parmanode functions are available.

# Part 2 dependencies

    if ! which docker > /dev/null 2>&1 ; then install_docker ; fi 
    if ! docker ps > /dev/null 2>&1 ; then start_docker_mac || return 1 ; fi 

# Part 3 dependencis
    
    #Linux needs qemu
    if [[ $OS == Linux ]] ; then
    sudo apt-get update
    sudo apt-get install -y qemu binfmt-support qemu-user-static
    docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
    fi


# Make necessary directories

    ParmanodL_directories ;  log "parmanodl" "directory function"

# Get OS , verify, and extract
    
    if [[ $1 == install ]] ; then OS_choice=pi ; fi

    if [[ $OS_choice == pi ]] ; then
    get_PiOS || { log "parmanodl" "failed at get_PiOS" ; exit ; }
    fi

    if [[ $OS_choice == mint ]] ; then
    get_Mint || { log "parmanodl" "failed at get_Mint" ; exit ; } 
    fi

# Macs use Docker functionality here
    
    ParmanodL_docker_run || { log "parmanodl" "failed at docker_run" ; exit ; }
    ParmanodL_docker_get_binaries || { log "parmanodl" "failed at docker_get_binaries" ; exit ; }
    

# Mount the image and dependent directories
    
    ParmanodL_mount || { echo "failed to mount. Exiting." ; log "parmanodl" "failed at ParmanodL_mount" ; exit ; }

# Setup system locale

    set_locale ; log "parmanodl" "reached set_local"

# Modify the image with chroot

    ParmanodL_chroot_docker ; log "parmanodl" "finished ParmanodL_chroot"

# Debug - opportunity to pause and check

    debug "Chroot finished. Pause to check."

# Unmount the image and system directories

    ParmanodL_unmount ; log "parmanodl" "finished ParmanodL_unmount"

# Get microSD device name into disk variable - user input here

    detect_microSD || { log "parmanodl" "failed at detect_microSD" ; exit ; }

# Write the image to microSD

    ParmanodL_write || { log "parmanodl" "failed at ParmanodL_write" ; exit ; }
    debug "pause"

# Clean known hosts of parmanodl
 
    clean_known_hosts ; log "parmanodl" "finished clean_known_hosts"

# make run_parmanodl for desktop execution

    make_Run_ParmanodL ; log "parmanodl" "finished make_run_parmanodL"

# Remove temporary script

    rm $HOME/Desktop/ParmanodL_Installer >/dev/null 2>&1 && log "parmanodl" "installer removed"
    
# Clean up the mess

    ParmanodL_cleanup

# Success output

    ParmanodL_success

# The End




########################################################################################
}
