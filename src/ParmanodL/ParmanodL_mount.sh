function ParmanodL_mount { 
clear
# Caculate offset for image, needed for mount command later.

   # if [[ $OS == Linux ]] ; then
   #    startSector=$(sudo fdisk -l $image_path | grep img2 | awk '{print $2}') >/dev/null
   #    byteOffset=$(($startSector*512)) >/dev/null
   #    sudo mount -v -o offset=$byteOffset -t ext4 $image_path /tmp/mnt/raspi || { \
   #    debug "mount failed." ; announce "Failed to mount. Aborting." ; return 1 ; }
   #    sudo mount --bind /dev /tmp/mnt/raspi/dev >/dev/null 2>&1 
   #    sudo mount --bind /sys /tmp/mnt/raspi/sys >/dev/null 2>&1
   #    sudo mount --bind /proc /tmp/mnt/raspi/proc >/dev/null 2>&1
   # fi

#   if [[ $OS == Mac ]] ; then
      docker exec -it -e image_file="${image_file}" ParmanodL /bin/bash -c "\
                                              mkdir -p /tmp/mnt/raspi ; \
                                              echo \"image_file is \$image_file\" ; \
                                              export startSector=\$(fdisk -l /mnt/ParmanodL/\$image_file | grep Linux | awk '{print \$2}') ; \
                                              export byteOffset=\$((\$startSector*512)) ; \
                                              mount -v -o offset=\$byteOffset -t ext4 /mnt/ParmanodL/\$image_file /tmp/mnt/raspi ; \
                                              mount --bind /dev /tmp/mnt/raspi/dev >/dev/null 2>&1 ; \
                                              mount --bind /sys /tmp/mnt/raspi/sys >/dev/null 2>&1 ; \
                                              mount --bind /proc /tmp/mnt/raspi/proc >/dev/null 2>&1 " \
                    || { echo "Failed to mount. Aborting. Hit <enter>" ; return 1 ; } 
#   fi

}

