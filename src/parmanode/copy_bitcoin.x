function copy_bitcoin {

#A function to import an existing drive for Parmanode
#Code just started,lots of work to do.

plug in drive containing blockchain
change label to parmanode

Take care with different bitcoin.conf



}

function parmanode_label {

if file -s /dev/$driveID | grep "fat" ; then
    if ! which dosfslabel ; then sudo apt install dosfs -y ; fi
sudo dosfslabel /dev/$driveID parmanode 


if file -s /dev/$driveID | grep -i "ntfs" ; then
    if ! which ntfslabel ; then sudo apt install ntfs-3g -y ; fi
sudo ntfslabel /dev/$driveID parmanode 


if file -s /dev/$driveID | grep -Ei "ext[234]" ; then
    if ! which e2label ; then sudo apt install e2fsprogs -y ; fi
sudo e2label /dev/$driveID parmanode 
}

