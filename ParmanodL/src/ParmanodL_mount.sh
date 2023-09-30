function ParmanodL_mount { 

# Caculate offset for image, needed for mount command later.

   if [[ $OS == Linux ]] ; then
      startSector=$(sudo fdisk -l $image | grep img2 | awk '{print $2}') >/dev/null
      byteOffset=$(($startSector*512)) >/dev/null
      mount -v -o offset=$byteOffset -t ext4 $image /tmp/mnt/raspi || { announced "Failed to mount. Aborting." ; return 1 ; }
      sudo mount --bind /dev /tmp/mnt/raspi/dev >/dev/null 2>&1 
      sudo mount --bind /sys /tmp/mnt/raspi/sys >/dev/null 2>&1
      sudo mount --bind /proc /tmp/mnt/raspi/proc >/dev/null 2>&1
   fi


   if [[ $OS == Mac ]] ; then
      docker exec -it ParmanodL /bin/bash -c "mkdir -p /tmp/mnt/raspi ; \
                                              export image='/mnt/ParmanodL/$image_file' ; \
                                              export startSector=$(sudo fdisk -l \$image | grep img2 | awk '{print \$2}') ; \
                                              export byteOffset=$(($startSector*512)) ; \
                                              mount -v -o offset=$byteOffset -t ext4 \$image /tmp/mnt/raspi ; \
                                              mount --bind /dev /tmp/mnt/raspi/dev >/dev/null 2>&1 ; \
                                              mount --bind /sys /tmp/mnt/raspi/sys >/dev/null 2>&1 ; \
                                              mount --bind /proc /tmp/mnt/raspi/proc >/dev/null 2>&1 " \
                    || { announced "Failed to mount. Aborting." ; return 1 ; } 
   fi

}

function ParmanodL_unmount {
   
# umount evertying

   if [[ $OS == Linux ]] ; then
      sudo umount /tmp/mnt/raspi/dev
      sudo umount /tmp/mnt/raspi/sys
      sudo umount /tmp/mnt/raspi/proc
      sudo umount /tmp/mnt/raspi
   fi

   if [[ $OS == Mac ]] ; then
      docker exec -it ParmanodL /bin/bash -c "sudo umount /tmp/mnt/raspi/dev ; \
                                              sudo umount /tmp/mnt/raspi/sys ; \
                                              sudo umount /tmp/mnt/raspi/proc ; \
                                              sudo umount /tmp/mnt/raspi"
   fi

}                