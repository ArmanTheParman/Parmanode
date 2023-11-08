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

if command -v gpg >/dev/null 2>&1
	then return 0 
fi

while true ; do #while 1

set_terminal

if [[ $(uname) == "Linux" ]] ; then #if 1

while true ; do # while 2

echo "
########################################################################################

                            Testing \"gpg\" checkpoint

    Parmanode has tested if the \"gpg\" command is available on your computer and it
    is not. 
    
    Gpg is necessary for certain commands that Parmanode will use, like verifying 
    signatures from developers who release their code. 

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
fi #end if 1

#still in while 1

if [[ $(uname) == Darwin ]] ; then #if 2
while true ; do # while 3
echo "
########################################################################################

                            Testing \"gpg\" checkpoint

    Parmanode has tested if the \"gpg\" command is available on your computer and it
    is not. 
    
    Gpg is necessary for certain commands that Parmanode will use, like verifying 
    signatures from developers who release their code. 

    Parmanode can install gpg for you if you like:

                              (g)      Install gpg

########################################################################################
"
choose "xq"
read choice
debug2 "after read choice"
case $choice in
g) 
gpg4mac ; return 0 ;;
q) 
exit 0 ;;
*) 
invalid ;;
esac
done #end while 3

fi #end if 2 

clear
echo "
########################################################################################
    Unexpecte error in gpg check function. Aborting. Please report to Parman.
########################################################################################
Hit <enter> to continue.
"
read
exit
done #end while 1
return 0
}


function curl_check {
if [[ -z $(command -v curl) ]] ; then
while true ; do
set_terminal ; echo -e "
########################################################################################

    The program$cyan curl$orange needs to be installed on your computer for Parmanode to work.
    It's a small command line program that is used to download links from the 
    internet. It's quite unusual that Parmanode hasn't been able to detect it as 
    most Linux and Mac operating systems come with it. 
    
    On Macs, it requires$cyan Homebrew$orange to be installed first - that can take an hour or so.
    
                          i)          Install curl

                          q)          Quit

########################################################################################
"
choose "xpmq" ; read choice
case $choice in 
m|M) back2main ;;
q|Q|Quit|QUIT) exit 0 ;; p|P) return 1 ;; 

    i|I)
    if [[ $OS == "Linux" ]] ; then sudo apt-get install curl -y ; break ; fi 
    if [[ $OS == "Mac" ]] ; then brew_check curl ; brew install curl ; break ; fi
    ;;

    *) invalid ;; 
esac 
done
fi

return 0
}

function check_for_python {
if ! which python3 >/dev/null ; then return 1 ; else return 0 ; fi
}
