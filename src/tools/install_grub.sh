function install_grub {
    
if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

yesorno "This will install (or reinstall) the GRUB bootloader for Linux only,
    and for x86_64-efi systems. Don't proceed if this is not matching your system.

    The command is...
$cyan
    sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
    sudo update-grub
$orange

    Continue?" || return 1

clear
sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
sudo update-grub

enter_continue "done"
}
