function sudo_check {

set_terminal
if [[ $OS == "Linux" ]] ; then
    if command -v sudo >/dev/null ; then
        if id | grep -q sudo >/dev/null 2>&1 ; then return 0 
        fi
	fi
fi

if [[ $OS == "Mac" ]] ; then
    if command -v sudo >/dev/null 2>&1 ; then return 0 
    fi
fi

########################################################################################
#If code reaches here, sudo not available...
########################################################################################

if [[ $OS == "Mac" ]] ; then
echo "
########################################################################################

                            Testing \"sudo\" checkpoint

    Parmanode has tested if the \"sudo\" command is available on your computer and it
    is not. The test failed. The program can not continue and will exit. Sudo is 
    necessary for certain commands that Parmanode will use, like mounting and 
    formatting the external drive.

    It's possible that \"sudo\" has been disabled on your system. Until this is
    rectified, you cannot use Parmanode. Terribly sorry. Have a lovely day.

#########################sudo_check###############################################################
"
enter_exit ; exit 1 #enter_exit is a basic custom printing command.
fi

if [[ $OS == "Linux" ]] ; then
echo "
########################################################################################

                            Testing \"sudo\" checkpoint

    Parmanode has tested if the \"sudo\" command is available on your computer and it
    is not. The test failed. The program can not continue and will exit. Sudo is 
    necessary for certain commands that Parmanode will use, like mounting and 
    formatting the external drive.

    If you can't get passed this checkpoint, you could try venturing into the world
    of learning to use the command line, and install sudo with the command:

                                 apt-get install sudo

    You will need to run this as the root user (no you can't run Parmanode as root).

########################################################################################
"
enter_exit ;
exit 
fi
}

##############################################################################################################


function gpg_check {

while true ; do #while 1

set_terminal

	if command -v gpg >/dev/null 2>&1
	then return 0 
	fi
if [[ $OS == "Linux" ]] ; then

while true ; do # while 2

echo "
########################################################################################

                            Testing \"gpg\" checkpoint

    Parmanode has tested if the \"gpg\" command is available on your computer and it
    is not. The test failed. The program can not continue and will exit. gpg is 
    necessary for certain commands that Parmanode will use, like verifying 
    signatures from developers who release their code. 

    Why did this happen? You may be running a minimalist version of gnu-Linux, as gpg
    is usually bundled together with Linux distributions.

    Parmanode can install gpg for you if you like:

                              (g)      Install gpg

########################################################################################
"
choose "xq"
read choice

	#Install gpg
	if [[ $choice == "g" ]] 
            then set_terminal ; sudo apt-get install gpg -y ; enter_continue ; set_terminal ; return 0 
            fi

	if [[ $choice == "q" ]] 
            then exit 0 ; else invalid ; continue
            fi
done #end while 2
fi #end if linux

#still in while 1

if [[ $OS == "Mac" ]] ; then
while true ; do # while 3
echo "
########################################################################################


                            Testing \"gpg\" checkpoint


    Parmanode has tested if the \"gpg\" command is available on your computer and it
    is not. The test failed. The program can not continue and will exit. gpg is 
    necessary for certain commands that Parmanode will use, like verifying 
    signatures from developers who release their code. 

    If you want Parmanode to install it for you using \"brew\", then you can select
    that. Note it takes a while if you don't already have brew installed. Parmanode 
    will take care of installing brew if needed. Note that the quickest way to get 
    gpg is to exit Parmanode and install gpg yourself from gpgtools.org


                        g)        Parmanode to install gpg 
                             
                        q)        Quit and install gpg yourself


########################################################################################
"
choose "xq"
read choice
case $choice in
g) install_gpg_mac ; break ;;
q) exit 0 ;;
*) invalid ;;
esac
done #end while 3

fi #end if Mac
done #end while 1
return 0
}


function curl_check {
if [[ -z $(command -v curl) ]] ; then
while true ; do
set_terminal ; echo "
########################################################################################

    The program curl needs to be installed on your computer for Parmanode to work.
    It's a small command line program that is used to download links from the 
    internet.
    
                          i)          Install curl

                          q)          Quit

########################################################################################
"
choose "xpmq" ; read choice
case $choice in 
m) back2main ;;
q|Q|Quit|QUIT) exit 0 ;; p|P) return 1 ;; 

    i|I)
    if [[ $OS == "Linux" ]] ; then sudo apt-get install curl -y ; break ; fi 
    if [[ $OS == "Mac" ]] ; then brew install curl ; break ; fi
    ;;

    *) invalid ;; 
esac 
done
fi

return 0
}

function git_check {
if [[ $OS == "Linux" ]] ; then    # if the os is linux, then
if ! which git ; then             # check that git doesn't exist, then
sudo apt-get install git -y       # install git
fi  
fi
}

function check_for_python {
if ! which python3 >/dev/null ; then return 1 ; else return 0 ; fi
}
