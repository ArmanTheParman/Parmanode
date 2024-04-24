function ParmanodL_cleanup {

# unmount image

    sudo umount -f ${disk}* >/dev/null 2>&1

# stop and remove docker container

    # if [[ $OS == Mac ]] ; then
        if docker ps -a | grep -q ParmanodL ; then docker stop ParmanodL >/dev/null 2>&1 ; docker rm ParmanodL >/dev/null 2>&1 ; fi
    # fi

# Remove temporary directories

    sudo rm -rf /tmp/mnt

# Remove script file
    rm ~/ParmanodL/chroot_function.sh 2>/dev/null


while true ; do
set_terminal ; echo "
########################################################################################

    Do you want the zip and image files deleted off your computer? - They're big files
    and you can save some space.

                                   y   or   n 

########################################################################################
"
choose "x" ; read choice 

case $choice in 
y|Y|YES|yes|Yes) 
   rm $HOME/ParmanodL/*
   return 0
   ;;
n|N|No|NO|no)
   return 0
   ;;
*)
   invalid
   ;;
esac
done


return 0

}