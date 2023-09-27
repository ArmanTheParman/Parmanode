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

#prep
sudo chroot /mnt/raspi /bin/bash -c "groupadd -r parman ; useradd -m -g parman parman ; usermod -aG sudo parman ; exit "
sudo chroot /mnt/raspi /bin/bash -c 'echo "parman:parmanodl" | chpasswd ; systemctl enable ssh ; exit'
sudo chroot /mnt/raspi /bin/bash -c "apt purge piwiz -y ; exit" 
sudo chroot /mnt/raspi /bin/bash -c 'echo "en_US.UTF-8 UTF-8" | tee /etc/locale.gen ; exit'
sudo chroot /mnt/raspi /bin/bash -c "locale-gen ; update-locale LANG=en_US.UTF-8 ; exit " 
sudo chroot /mnt/raspi /bin/bash -c 'echo "Defaults lecture=never" >> /etc/sudoers ; exit'
sudo chroot /mnt/raspi /bin/bash -c 'echo "" > /etc/motd ; exit'
sudo chroot /mnt/raspi /bin/bash -c 'sed -i "/autologin-user=/d" /etc/lightdm/lightdm.conf ; exit' 
sudo chroot /mnt/raspi /bin/bash -c 'userdel rpi-first-boot-wizard ; exit'

#start orange colour in 10-uname script 
#append baner code
#append password change if statment
#append colour reversion 

#getting error here, "around | - think I found it and fixed"
sudo chroot /mnt/raspi /bin/bash -c 'echo "printf \"\\033[38;5;214m\"" | tee -a /etc/update-motd.d/10-uname ; exit' 

echo 'WELCOME TO...

.______      ___      .______    .___  ___.      ___      .__   __.   ______    _______   __      
|   _  \    /   \     |   _  \   |   \/   |     /   \     |  \ |  |  /  __  \  |   __  \ |  |     
|  |_)  |  /  ^  \    |  |_)  |  |  \  /  |    /  ^  \    |   \|  | |  |  |  | |  T  |  ||  |     
|   ___/  /  /_\  \   |      /   |  |\/|  |   /  /_\  \   |  `    | |  |  |  | |  |  |  ||  |     
|  |     /  _____  \  |  |\  \   |  |  |  |  /  /   \  \  |  | `  | |  |__|  | |  |__|  ||  |____
| _|    /__/     \__\ | _| `._\__|__|  |__| /__/     \__\ |__| \__|  \______/  |_______/ |_______|


if [ \! -e /.password_changed ] ; then 

echo "THE DEFAULT PASSWORD IS parmanodl (NOTE IT ENDS IN l)."
echo ""
echo "YOU MUST CHANGE THE PI'"'"'S PASSWORD TO CONTINUE"

passwd parmanode && touch /.password_changed
fi
' > $HOME/parman_programs/ParmanodL/banner.txt

sudo cp $HOME/parman_programs/ParmanodL/banner.txt /mnt/raspi/tmp/banner.txt

sudo chroot /mnt/raspi /bin/bash -c 'cat /tmp/banner.txt >> /etc/update-motd.d/10-uname ; exit'
rm $HOME/parman_programs/ParmanodL/banner.txt
sudo chroot /mnt/raspi /bin/bash -c 'rm /tmp/banner.txt'

# umount evertying
sudo umount /mnt/raspi/dev
sudo umount /mnt/raspi/sys
sudo umount /mnt/raspi/proc
sudo umount /mnt/raspi
}

function write_image {
#dd the drive
# umount first
sudo umount /dev/sdb*

# * doesn't work in dd command
file=$(ls *.img)
dd if=$file of=/dev/sdb bs=4M status=progress 
sync
}


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

# can search $HOME/.ssh/known_hosts for IP address and delete that line
}
