ParmanodL_mount () { 
if [[ $(uname) == Linux ]] ; then
# Caculate offset for image, needed for mount command later.
start=$(sudo fdisk -l $HOME/parman_programs/ParmanodL/2023-05-03-raspios-bullseye-arm64.img | grep img2 | awk '{print $2}') >/dev/null
start2=$(($start*512)) >/dev/null
fi

if [[ $(uname) == Darwin ]] ; then
start=$(gdisk -l $HOME/parman_programs/ParmanodL/2023-05-03-raspios-bullseye-arm64.img | grep "Linux filesystem" | awk '{print $2}') >/dev/null
start2=$(($start*512)) >/dev/null
fi

# Make mountpoint
if [[ ! -e /tmp/mnt/raspi ]] ; then sudo mkdir -p /tmp/mnt/raspi ; fi

# Mount
sudo mount -v -o offset=$start2 -t ext4 2*.img /tmp/mnt/raspi >/dev/null || { echo "failed mount" ; return 1 ; }

# Bind file systems needed, just in case.
sudo mount --bind /dev /tmp/mnt/raspi/dev >/dev/null 2>&1 
sudo mount --bind /sys /tmp/mnt/raspi/sys >/dev/null 2>&1
sudo mount --bind /proc /tmp/mnt/raspi/proc >/dev/null 2>&1
fi
}

function ParmanodL_unmount {
# umount evertying
sudo umount /tmp/mnt/raspi/dev
sudo umount /tmp/mnt/raspi/sys
sudo umount /tmp/mnt/raspi/proc
sudo umount /tmp/mnt/raspi
}                