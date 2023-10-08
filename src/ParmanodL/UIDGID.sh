function UIDGID {
if [[ -z $1 ]] ; then umbrel="Umbrel" ; fi

while true ; do
set_terminal ; echo -e "
########################################################################################

        The$cyan user ID (UID)$orange and the$cyan group ID (GID)$orange needs to be set for the $umbrel
        files and directories on the target drive, so your PamanodL Linux comuper can
        read/write to them.

        Typically, if the Linux machine has only one user, the UID and GID will each
        be 1000

        What would you like to do?

                d)      Use \"defaults\" UID=1000 and GID=1000

                m)      Manually enter different values

########################################################################################
"
read choice ; set_terminal 
case $choice in
d|D)
export pUID=1000 ; export pGID=1000
return 0
;;

m) 
set_terminal ; echo -e "
########################################################################################
    Please enter the UID :
########################################################################################

"
read pUID ; export pUID

set_terminal ; echo -c "
########################################################################################
    Please enter the GID :
########################################################################################

"
read pGID ; export pGID
return 0
;;

*) invalid ;;

esac
done
}