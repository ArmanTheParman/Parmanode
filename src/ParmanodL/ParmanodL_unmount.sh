function ParmanodL_unmount {
   
# umount evertying

   # if [[ $OS == Linux ]] ; then
   #    sudo umount /tmp/mnt/raspi/dev
   #    sudo umount /tmp/mnt/raspi/sys
   #    sudo umount /tmp/mnt/raspi/proc
   #    sudo umount /tmp/mnt/raspi
   # fi

   # if [[ $OS == Mac ]] ; then
      docker exec -it ParmanodL /bin/bash -c "umount /tmp/mnt/raspi/dev ; \
                                              umount /tmp/mnt/raspi/sys ; \
                                              umount /tmp/mnt/raspi/proc ; \
                                              umount /tmp/mnt/raspi"
   # fi

}                