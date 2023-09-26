function install_ParmanodL {

mkdir -p $HOME/parman_programs/ParmanodL 
cd $HOME/parman_programs/ParmanodL
curl -LO https://downloads.raspberrypi.org/raspios_arm64/images/raspios_arm64-2023-05-03/2023-05-03-raspios-bullseye-arm64.img.xz

if ! shasum -a 256 *.img.xz | grep e7c0c89db32d457298fbe93195e9d11e3e6b4eb9e0683a7beb1598ea39a0a7aa ; then
echo "sha256 failed. Aborting"
enter_continue
return 1
fi

# unzip the image:
xz -vkd *.img.xz
#rm *.img.xz

start=$(sudo fdisk -l *.img | grep img2 | awk '{print $2'})
start2=$(($start*512))

sudo mkdir -p /mnt/raspi

sudo mount -v -o offset=$start2 -t ext4 *.img /mnt/raspi

sudo mount --bind /dev /mnt/raspi/dev
sudo mount --bind /sys /mnt/raspi/sys
sudo mount --bind /proc /mnt/raspi/proc

sudo chroot /mnt/raspi /bin/bash
}