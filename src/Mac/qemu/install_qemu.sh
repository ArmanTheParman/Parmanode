return 0
# don't use
function install_qemu {
    brew install qemu
#create disk image
qemu-img create -f qcow2 ~/VMs/ubuntu_vm.qcow2 20G

# run from cd and mount drive -, -boot d means bood from CD rom, c means hdd
qemu-system-x86_64 -m 2G -hda ~/VMs/ubuntu_vm.qcow2 -cdrom ~/Downloads/ubuntu.iso -boot d -drive file=/dev/disk6s1,format=raw

#run image with ext drive
qemu-system-x86_64 -m 2G -hda ~/VMs/ubuntu_vm.qcow2 -drive file=/dev/disk6s1,format=raw


qemu-system-x86_64 -m 2G -hda ~/VMs/ubuntu_vm.qcow2 -drive file=/dev/disk6s1,format=raw

}