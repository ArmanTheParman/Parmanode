function format_assist {
clear
echo -e "
########################################################################################
$cyan 
                             Drive Format Assist Tool
$orange
    Sometimes the automated functions in Parmanode won't work to format the drive, 
    for one reason or another. 
    
    It's not necessarily a bug, it's just that some drives aren't going to be 
    detected by the system as expected, so some manual intervention is required. This 
    tool will assist you through it.

    The usual detection method asks you to remove then connect the target drive,
    allowing Parmanode to measure the drive state in the two scenarious and record it
    in a text file. It then does a subtraction, then the remainder will be the details 
    of the drive. It's designed this way so that the user doesn't have to decide for 
    themselves what the drive is called, potentially introducing serious error.

    If that's not working for you, let's do it manually...

    If you're using a Mac, the easiest way is to open Disk Utility, and use that 
    program to format the drive. Search on line for guidance if it's not intuitive
    enough, or ask for help in the Parmanode Telegram chat. Myself or another user will
    help you. After that, \"import the drive\" as a Parmanode drive. That option is
    in the tools-->migrate menu.

    If you're using Linux, read on...

########################################################################################
"
choose "epq"
read choice
case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; 
esac


clear
echo -e "
########################################################################################

   The commands $cyan 'lsblk'$orange and$cyan 'sudo blkid'$orange will list your drives.$cyan 'sudo'$orange is needed with
   the blkid command in order to refresh the state - I don't know why.
$green
   You can open a new terminal window to do this as you read these instructions.
$cyan
   Determine which is your drive. The clues will be the drive size and the output
   changes as you connect and disconnect the drive.

   A typical result will be something like:
$cyan
               /dev/sdb
$orange
   Ignore any numbers after the final letter, eg if you have /dev/sdb1, just note 
   down /dev/sdb. 

   It's very important you are sure you have the right drive. Formatting the wrong
   one can be a disaster.

########################################################################################
"
enter_continue

clear
echo -e "
########################################################################################

    Once you have the drive name, we need to open the$cyan fdisk$orange utility and start from 
    scratch, wiping the partitions.
$green
             sudo umount -f /dev/sdb
$orange
    You may not need the '-f', force, directive, but it's there anyway. Note it says
    'umount' not 'unmount'.             

    Only after the drive is unmounted can we perform fdisk operations...
$green
             sudo fdisk /dev/sdb
$orange    
    Now hit$cyan 'm'$orange if you want to see options or$red q$orange to quit, but for simplicity, just
    follow along...
$green
    Hit g <enter> w <enter>
$orange
    This will write a new partition to the drive and exit fdisk. All the data would now 
    be lost on the drive, but it still needs to be formatted.

########################################################################################
"
enter_continue
clear
echo -e "
########################################################################################
    
    At this point, if you return to the Bitcoin installation and select 'external'
    drive, Parmanode is likely to detect the drive now as normal.

    If you want to continue to manually do it, great...

########################################################################################
"
choose "epq"
read choice
case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; 
esac
clear ; echo -e "
########################################################################################

    The next thing to do is to format the drive. I suggest you do$cyan 'lsblk'$orange and 
$cyan    'sudo blkid'$orange again, just to be sure there are no changes to the drive names.

    Then, we can format the drive...
$green
    sudo mkfs.ext4 -F -L \"parmanode\" /dev/sdb
$orange
    Remember to put the right name, don't just blindly copy /dev/sdb

    This will format the drive to the ext4 file system (standard for Linux), and at
    the same time will label the drive to \"parmanode\".

########################################################################################
"
enter_continue
clear
echo -e "
########################################################################################

    This will now surely be detected by Parmanode, so you can import the drive 
    without issues. But you can continue with super manual tweaks...

########################################################################################
"
choose "epq"
read choice
case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; 
esac

set_terminal_wide ; echo -e "

##############################################################################################################

    The next thing to do is to make an entry in /etc/fstab so that the drive mounts when the computer 
    reboots. Ths is not strictly necessary - sometimes the drive mounts anyway when you log in, but with
    the fstab entry, it will mount BEFORE you log in after a reboot. This is what you want if you need
    the computuer to continue syncing Bitcoin without your intervention in the event of an unexpected
    reboot.

    I DO NOT RECOMMEND YOU TO DO THIS MANUALLY, IT IS DANGEROUS; ANY ERRORS CAN MAKE YOUR COMPUTER 
    UNRESPONSIVE LIKE A BRICK. THIS IS FOR INFORMATIONAL PURPOSES ONLY. IT'S BEST THAT PARMANODE DOES THIS 
    FOR YOU AUTOMATICALLY WHEN YOU IMPORT.
    
    You first need the UUID, extracted from the$cyan 'sudo blkid'$orange command. Then the following line needs to be 
    typed out exactly (replace \$UUID with the actual string of the UUID, and any spaces where they 
    shouldn't be can break your computer; eg no space after that comma)
  $red  
    echo "UUID=\$UUID /media/$USER/parmanode ext4 defaults,nofail 0 2" | sudo tee -a /etc/fstab 
    $orange
    It's best if you back up this file '/etc/fstab' so that if your computer 'breaks' you can restore it
    in emergency boot up mode. Note, sometimes, just removing the external drive and rebooting can work if 
    your computer goes funny after this. Then, you can simply replace the new file with the backup.

##############################################################################################################
"
enter_continue

set_terminal
echo -e "
########################################################################################

    To trick Parmanode into accepting the drive without going through the import 
    process, then next thing to do is to create a hidden directory in the drive's 
    root directory.
    
    Mount the drive...

        sudo mount /dev/sdb/ /media/$USER/parmanode/
    
    This mounts the drive to the correct location for Parmanode to function properly.
    If the /media/$USER/parmanode/ directory doesn't exist, you need to create it
    manually in order to mount it there, but if fstab will be mounting the drive, then
    the parmanode directory does not need to exist.




}