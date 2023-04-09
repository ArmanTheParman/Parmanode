# This page needs a log of work and has errors.


function sudo_check {
set_terminal
if command -v sudo >/dev/null 2>&1
	then return 0
else
	echo "Need sudo to run Parmanod. Aborting"
	enter_continue
	exit 0
	fi


function sudo_check_temp {

set_terminal

if command -v sudo >/dev/null 2>&1
	then return 0 
	fi

echo "
########################################################################################

                            Testing \"sudo\" checkpoint

    Parmanode has tested if the \"sudo\" command is available on your computer and it
    is not. The test failed. The program can not continue and will exit. Sudo is 
    necessary for certain commands that Parmanode will use, like mounting and 
    formatting the external drive." 

if [[ $OS = "Mac" ]] ; then
    echo "
    It's possible that \"sudo\" has been disabled on your system. Until this is
    rectified, you cannot use Parmanode. Terribly sorry. Have a lovely day.

########################################################################################
"
enter_exit ; exit 1
else
echo "
    If you can't get passed this checkpoint, you could try venturing into the world
    of learning to use the command line, and install sudo with the command:

                                 apt install sudo

    You will need to run this as the root user (no you can't run Parmanode as root).

########################################################################################
"
fi
enter_exit ;
exit 1
}


function gpg_check {
if command -v gpg >/dev/null 2>&1 ; then
return 0
else
echo "Parmanode needs gpg to run. Aborting"
enter_continue
exit 1
}



function gpg_check_temp {
while true ; do
set_terminal
if command -v gpg >/dev/null 2>&1
then return 0 
fi

if [[ $OS == "Linux" ]] ; then
while true ; do
echo "
########################################################################################

                            Testing \"gpg\" checkpoint

    Parmanode has tested if the \"gpg\" command is available on your computer and it
    is not. The test failed. The program can not continue and will exit. gpg is 
    necessary for certain commands that Parmanode will use, like verifying 
    signatures from developers who release their code. 

    Why did this happen? You may be running a minimalist version of gnu-Linux, as gpg
    is usually bundled together with Linux distributions.

    Parmanode can instal gpg for you if you like:

                              (g)      Install gpg

########################################################################################
"
choose "xq"
read choice

#Install gpg
if [[ $choice == "gpg" ]] ; then 
set_terminal ; sudo apt-get install gpg -y ; enter_continue ; set_terminal ; break ; fi

if [[ $choice == "q" ]] ; then exit 0 ; fi

invalid ; continue
done



if [[ $OS == "Mac" ]] ; then
while true ; do
echo "
########################################################################################

                            Testing \"gpg\" checkpoint

    Parmanode has tested if the \"gpg\" command is available on your computer and it
    is not. The test failed. The program can not continue and will exit. gpg is 
    necessary for certain commands that Parmanode will use, like verifying 
    signatures from developers who release their code. 

    If you want Parmanode to install it for you using \"brew\", then you can select
    that. Note it takes a while if you don't already have brew installed. 
    Parmanode will take care of installing brew if needed. Note that the quickest way
    to get gpg is to exit Parmanode and install gpg yourself from gpgtools.org

                          g)      Parmanode to install gpg 
                             
                          q)      Quit and install gpg yourself

########################################################################################
"
choose "xq"
read choice
if [[ $choice == "g" ]] ; then install_gpg_mac ; fi
if [[ $choice == "q" ]] ; then exit 0 ; fi
invalid
continue
done
fi
return 0
}
