# Script will exist at parmanode.com/parmanodel_PI64.sh
return 0

function temporary_function {
printf '\033[8;38;88t' && echo -e "\033[38;2;255;145;0m" 

# User to type: 
#        /bin/bash -c "$(curl -fsSL https://parmanode.com/parmanodl_PI64.sh)" 

# Mac Version

if [[ $(uname -s) == Darwin ]] ; then


if ! which brew ; then
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 
   if ! which brew ; then export warning=1 ; fi
fi

if ! greadlink ; then
    if [[ $warning == 1 ]] ; then echo "problem with homebrew, needed to install coreutils/greadlink. Aborting." ; sleep 4 ; exit ; fi
    brew install coreutils
fi

if ! which git ; then
   if [[ $warning == 1 ]] ; then echo "problem with homebrew, needed to install git. Aborting." ; sleep 4 ; exit ; fi
   brew install git
fi

if [ ! -e ~/parman_programs/parmanode/src ] ; then
   mkdir -p ~/parman_programs
   cd ~/parman_programs
   git clone --depth 1 https://github.com/armantheparman/parmanode.git
fi

########################################################################################
cat << 'EOF' > ~/Desktop/make_parmanodl.sh
#!/bin/bash
printf '\033[8;38;88t' && echo -e "\033[38;2;255;145;0m" 
clear
echo "
########################################################################################

                       P  A  R  M  A  N  O  D  L     O  S 

    You are installing ParmanodL OS onto a microSD card, for use in a Raspberry Pi 4.

    The target microSD can be as small as 16GB.

    Hit <enter> to continue

########################################################################################
" ; read

cd ~/parman_programs/parmanode ; git pull ; clear
for file in ~/parman_programs/parmanode/ParmanodL/src/**/*.sh ; do source $file ; done
source_parmanode
ParmanodL_directories

# TO DO
#download Parmanodl.img
#detect MicroSD for Mac
#dd write to microSD, Mac
#instructions to insert into Pi
#new desktop icon "parmanode"
#    - script to ssh
#    - delete "known host" when first time run. Make a temp file in ~/.parmanodl


EOF
########################################################################################

sudo chmod +x ~/Desktop/make_parmanodl.sh
clear
echo "
########################################################################################

    Double click on the Desktop icon "make_parmanodl.sh" to continue.

########################################################################################
"
sleep 3
fi
}
