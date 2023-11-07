# To be kept at parmanode.com
return 0

########################################################################################
#!/bin/sh

printf '\033[8;38;88t' && echo -e "\033[38;2;255;145;0m" 

if [ -d $HOME/parman_programs/parmanode ] ; then
clear
#update parmanode if it exists...
cd $HOME/parman_programs/parmanode && git config pull.rebase false && git pull >/dev/null 2>&1

#make desktop clickable icon...
if [ ! -e $HOME/Desktop/run_parmanode.sh ] ; then
cat > $HOME/Desktop/run_parmanode.sh << 'EOF'
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

########################################################################################
# Test what's missing 
########################################################################################

if [[ ! -e /Library/Developer/CommandLineTools ]] ; then installed_cldt="[     ]" ; else installed_cldt="[ yes ]" ; fi

if ! which brew >/dev/null 2>&1 ;      then installed_hb="[     ]"  ; else installed_hb="[ yes ]" ; fi

if ! which git >/dev/null 2>&1 ;       then installed_git="[     ]" ; else installed_git="[ yes ]" ; fi

if ! which greadlink >/dev/null 2>&1 ; then installed_cu="[     ]"  ; else installed_cu="[ yes ]" ; fi 

if ! which ssh >/dev/null 2>&1 ;       then installed_ssh="[     ]" ; else installed_ssh="[ yes ]" ; fi

if ! which gpg >/dev/null 2>&1 ;       then installed_gpg="[     ]" ; else installed_gpg="[ yes ]" ; fi

########################################################################################

clear
echo "
########################################################################################
                   Necessary Prerequisites for Parmanode 
########################################################################################    


    Homebrew (Mac Package manager .................................. $installed_hb

    Command Line Developer Tools (for compiling software) .......... $installed_cldt

    Git (extracts software from GitHub) ............................ $installed_git

    Coreutils (some extra basic Mac commands Parmanode uses) ....... $installed_cu

    SSH (for remote access to your node) ........................... $installed_ssh

    gpg (for verifying software integrity).......................... $installed_gpg


########################################################################################

    Hit <enter> to proceed to install any missing components. <control-c> to exit.

"
read

if [[ $installed_hb == "[     ]" ]] ; then
