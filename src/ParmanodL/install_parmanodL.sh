function ParmanodL_build {
# HOW TO BUILD

# Need a Raspi 64 bit, with 32GB microSD capacity

# Prepare working directory
mkdir -p $HOME/parman_programs/ParmanodL 
cd $HOME/parman_programs/ParmanodL

#Rasbperry Pi OS, 64 bit, with Desktop.
curl -LO https://downloads.raspberrypi.org/raspios_arm64/images/raspios_arm64-2023-05-03/2023-05-03-raspios-bullseye-arm64.img.xz

# Check integrity.
if ! shasum -a 256 *.img.xz | grep e7c0c89db32d457298fbe93195e9d11e3e6b4eb9e0683a7beb1598ea39a0a7aa ; then
echo "sha256 failed. Aborting"
enter_continue
return 1
fi

# Unzip the image:
xz -vkd *.img.xz
}

function ParmanodL_mount {
# Caculate offset for image, needed for mount command later.
start=$(sudo fdisk -l *.img | grep img2 | awk '{print $2'})
start2=$(($start*512))

# Make mountpoint
sudo mkdir -p /mnt/raspi

# Mount
sudo mount -v -o offset=$start2 -t ext4 *.img /mnt/raspi

# Bind file systems needed, just in case.
sudo mount --bind /dev /mnt/raspi/dev
sudo mount --bind /sys /mnt/raspi/sys
sudo mount --bind /proc /mnt/raspi/proc

}

function ParmanodL_chroot {

sudo chroot /mnt/raspi /bin/bash -c ' groupadd -r parman ; useradd -m -g parman parman ; usermod -aG sudo parman ; echo "parman:parmanode" | chpasswd ; systemctl enable ssh ; sudo systemctl disable piwiz ; exit '

# umount evertying
sudo umount /dev/raspi/dev
sudo umount /dev/raspi/sys
sudo umount /dev/raspi/proc
sudo umount /dev/raspi

#dd the drive
# umount first
# sudo umount /dev/sdb*

dd if=*.img of=/dev/sdb bs=4M status=progress
sync

#Detect device connected
sudo arp-scan -l 


# % ssh parman@192.168.0.159
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
# Someone could be eavesdropping on you right now (man-in-the-middle attack)!
# It is also possible that a host key has just been changed.
# The fingerprint for the ECDSA key sent by the remote host is
# SHA256:x7waumHQska9XfttVKEfuDW9xgNObUWEcY2edlMEbSY.
# Please contact your system administrator.
# Add correct host key in /Users/ArmanK/.ssh/known_hosts to get rid of this message.
# Offending ECDSA key in /Users/ArmanK/.ssh/known_hosts:1
# ECDSA host key for 192.168.0.159 has changed and you have requested strict checking.
# Host key verification failed.

}
#!/bin/bash

function remove_sudo_lecture { 
# Check if the script is running as root
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root."
    exit 1
fi

# Check if the required setting is already in sudoers
grep -q "^Defaults lecture=never" /etc/sudoers

# $? is a special variable that holds the exit status of the last command executed
if [ $? -eq 0 ]; then
    echo "The sudo lecture is already turned off."
else
    # Append the setting to disable the lecture
    echo "Defaults lecture=never" >> /etc/sudoers
    echo "Sudo lecture has been turned off."
fi
}


function make_gnome_background_black { 
dconf write /org/gnome/terminal/legacy/profiles:/$(dconf list /org/gnome/terminal/legacy/profiles:/ | grep '^:[0-9a-f]*\./$')background-color "'rgb(0,0,0)'"
}
