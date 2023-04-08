function sudo_check {

while true ; do
set_terminal

if command -v sudo >/dev/null 2>&1

then break

else echo "
########################################################################################

                            Testing \"sudo\" checkpoint

    Parmanode has tested if the \"sudo\" command is available on your computer and it
    is not. The test failed. The program can not continue and will exit. Sudo is 
    necessary for certain commands that Parmanode will use, like mounting and 
    formatting the external drive. 

    If you can't get passed this checkpoint, you could try venturing into the world
    of learning to use the command line, and install sudo with the command:

                                 apt install sudo

    You will need to run this as the root user (no you can't run Parmanode as root).

########################################################################################
"
enter_exit ; break
fi

done
return 0
}

function gpg_check {

while true ; do

set_terminal
if command -v gpg >/dev/null 2>&1
then break

else echo "
########################################################################################

                            Testing \"gpg\" checkpoint

    Parmanode has tested if the \"gpg\" command is available on your computer and it
    is not. The test failed. The program can not continue and will exit. gpg is 
    necessary for certain commands that Parmanode will use, like verifying 
    signatures from developers who release their code. 

    Why did this happen? You may be running a minimalist version of gnu-Linux, as gpg
    is usually bundled together with Linux distributions.

    Parmanode can instal gpg for you if you like:

                              (gpg)      Install gpg

########################################################################################
"
choose "x"
read choice

#Install gpg
if [[ $choice != "gpg" ]] ; then exit 0 ; fi
set_terminal
sudo apt-get install gpg -y
enter_continue ; set_terminal
break
fi
done
return 0
}