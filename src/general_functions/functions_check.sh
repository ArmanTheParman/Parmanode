function sudo_check {

set_terminal
if [[ $OS != "Mac" ]] ; then
if command -v sudo && id | grep sudo >/dev/null 2>&1
	then return 0 
	fi
else
if command -v sudo >/dev/null 2>&1 ; then return 0 ; fi
fi

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
enter_exit ; exit 1
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

                                 apt install sudo

    You will need to run this as the root user (no you can't run Parmanode as root).

########################################################################################
"
enter_exit ;
exit 1
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
if [[ $choice == "g" ]] ; then install_gpg_mac ; break ; fi    #break out to while 1
if [[ $choice == "q" ]] ; then exit 0 ; fi
invalid
continue #cycle back through while 3
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
choose "xpq" ; read choice
case $choice in q|Q|Quit|QUIT) exit 0 ;; p|P) return 1 ;; 

    i|I)
    if [[ $OS == "Linux" ]] ; then sudo apt install curl -y ; break ; fi 
    if [[ $OS == "Mac" ]] ; then brew install curl ; break ; fi
    ;;

    *) invalid ;; 
esac 
done
fi

return 0
}

function git_check {
if [[ $OS == "Linux" ]] ; then
if ! which git ; then
sudo apt-get install git -y
fi ; fi

}

