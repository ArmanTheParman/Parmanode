return 0
########################################################################################
# This is the install script kept at
# https://parmanode.com/install_4mac.sh - the URL is easier to remember and shorter 
# than if keeping it on Github.

# If you 


########################################################################################
#!/bin/sh

printf '\033[8;38;88t' && echo -e "\033[38;2;255;145;0m" 

if [ -d $HOME/parman_programs/parmanode ] ; then
clear
#update parmanode if it exists...
cd $HOME/parman_programs/parmanode && git config pull.rebase false && git pull >/dev/null 2>&1

#make desktop clickable icon...
if [ ! -e $HOME/Desktop/run_parmanode ] ; then
cat > $HOME/Desktop/run_parmanode << 'EOF'
#!/bin/bash
cd $HOME/parman_programs/parmanode/
./run_parmanode.sh
EOF
sudo chmod +x $HOME/Desktop/run_parmanode*
echo "New clickable desktop icon made."
fi

#no further changes needed.
echo "Parmnode already downloaded."
exit
fi

#Assuming not previously installed parmanode...

    if ! which git ; then 

        if ! which brew >/dev/null ; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 
        if ! which brew >/dev/null ; then export warning=1 ; fi
        fi

        if ! which greadlink >/dev/null ; then
            if [ $warning = 1 ] ; then echo "problem with homebrew, needed to install coreutils/greadlink. Aborting." ; sleep 4 ; exit ; fi
            brew install coreutils
        fi

        if ! which ssh >/dev/null ; then 
            if [ $warning = 1 ] ; then echo "problem with homebrew, needed to install git. Aborting." ; sleep 4 ; exit ; fi
            brew install ssh 
        fi

        if ! which gpg >/dev/null ; then 
            if [ $warning = 1 ] ; then echo "problem with homebrew, needed to install git. Aborting." ; sleep 4 ; exit ; fi
            brew install gpg 
        fi

        brew install git
    fi

######################################################################################################################################################

# Parmanode first time install most likely...

mkdir -p $HOME/parman_programs >/dev/null 2>&1 
cd $HOME/parman_programs
git clone https://github.com/armantheparman/parmanode.git

#make desktop clickable icon...
if [ ! -e $HOME/Desktop/run_parmanode.command ] ; then
cat > $HOME/Desktop/run_parmanode << 'EOF'
#!/bin/bash
cd $HOME/parman_programs/parmanode/
./run_parmanode.sh
EOF
sudo chmod +x $HOME/parman_programs/run_parmanode.command >/dev/null 2>&1
clear
echo "
########################################################################################

    There should be an icon on the desktop for you, \"run_parmanode\".

    If you double click it, and your Mac is configured to open a text editor instead
    of running the program, that can be overcome by typing this in terminal:


                         $HOME/Desktop/run_parmanode

    It's case sensitive.

########################################################################################
"
exit
fi


