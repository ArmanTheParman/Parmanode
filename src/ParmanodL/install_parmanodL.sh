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

sudo chroot /mnt/raspi /bin/bash -c " groupadd -r parman ; useradd -m -g parman parman ; usermod -aG sudo parman ;\\
echo "parman:parmanode" | chpasswd ; systemctl enable ssh ; apt purge piwiz -y ; echo "en_US.UTF-8 UTF-8" | \\
tee -a /etc/locale.gen ; locale-gen ; update-locale LANG=en_US.UTF-8 ; echo "Defaults lecture=never" >> /etc/sudoers ; exit " 

# umount evertying
sudo umount /mnt/raspi/dev
sudo umount /mnt/raspi/sys
sudo umount /mnt/raspi/proc
sudo umount /mnt/raspi

#dd the drive
# umount first
sudo umount /dev/sdb*

# * doesn't work in dd command
file=$(ls *.img)
dd if=$file of=/dev/sdb bs=4M status=progress 
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

# can search $HOME/.ssh/known_hosts for IP address and delete that line
}