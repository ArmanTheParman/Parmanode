function ParmanodL_cleanup {

# unmount image

    sudo umount -f ${disk}* >/dev/null 2>&1

# stop and remove docker container

if docker ps -a | grep -q ParmanodL ; then docker stop ParmanodL >/dev/null 2>&1 ; docker rm ParmanodL >/dev/null 2>&1 ; fi

# Remove temporary directories

    sudo rm -rf /tmp/mnt

# Remove script file
    mv ~/ParmanodL/chroot_function.sh /tmp/"chroot_function_$(date)" 2>/dev/null


while true ; do
set_terminal ; echo -e "
########################################################################################

    Do you want the zip and image files deleted off your computer? - They're big files
    and you can save some space.

                                   y   or   n 

########################################################################################
"
choose "xmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
q|Q) exit ;; m|M) back2main ;;
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