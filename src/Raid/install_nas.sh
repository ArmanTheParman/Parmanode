function install_nas {
return 0


# Just taking notes at this stage.
set_terminal

#Make a new user for better security

sudo adduser nasuser
sudo usermod -aG sudo nasuser

########################################################################################
# Set up NFS (file sharing protocol)
########################################################################################
sudo apt install nfs-kernel-server -y

# set up export directory

# copy to /etc/exports
# /srv/nfs/share1 192.168.0.0/24(rw,sync,no_subtree_check,all_squash,anonuid=$uid,anongid=$gid)
# or
# /srv/nfs/share2 192.168.0.100(ro,sync,no_subtree_check)

# apply changes to table.
sudo exportfs -arv
sudo systemctl restart nfs-kernel-server

########################################################################################
# mount on the client side
########################################################################################
# resvport selects a port lowever than 1024, an admin port
# sudo mount -t nfs -o resvport,rw $IP:/mounted_directory /preverred_mount_point

# example fstab entry, mac or linux
# 192.168.3.1:/nas /mountpoint nfs rw,nolockd,resvport,hard,bg,intr,rw,tcp,rsize=65536,wsize=65536


########################################################################################
# RAID
########################################################################################
# sudo apt install mdadm

# sudo mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 /dev/sda /dev/sdb
# sudo mkfs.ext4 /dev/md0
# for fstab...
# UUID=your-raid-uuid /mnt/raid1 ext4 defaults,nofail 0 2
# Check status
# sudo mdadm --detail /dev/md0
# Important to wait for rsync to status in the report to reach 100% before using it

########################################################################################
##For windows nfs
##sudo apt-get update
##sudo apt-get install nfs-kernel-server
########################################################################################
}