function format_assist {
clear
echo -e "
########################################################################################
$cyan 
                             Drive Format Assist Tool
$orange
    Sometimes the automated functions in Parmanode won't work to format the drive, 
    for one reason or another. Some drives aren't going to be detected by the 
    system as expected, so some manual intervention is required. This tool will 
    assist you through it.

    The usual detection method asks you to remove then connect the target drive,
    allowing Parmanode to measure the drive state in the two scenarios and record it
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
choose "emq"
read choice
case $choice in
q|Q) exit 0 ;; m|M) back2main ;; 
esac

clear
echo -e "
########################################################################################
$cyan
    There are a few things to do to manually 'import' the drive to Parmanode...
$orange
                        1)  Format drive to ext4
                        2)  Fstab entry
                        3)  Correct mount point
                        4)  Mount point permissions
                        5)  Mount the drive
                        6)  UUID in parmanode.conf (optional)
                        7)  Make .bitcoin directory
                        8)  symlink to ext drive
                        9)  drive setting in parmanode.conf 
                        10) make bitcoin.conf 
   
   I will go through each in deatail and in order...

########################################################################################
"
choose "emq"
read choice
case $choice in
q|Q) exit 0 ;; m|M) back2main ;; 
esac


clear
echo -e "
########################################################################################
$cyan
                              FORMATTING THE DRIVE
$orange
   The commands $cyan 'lsblk'$orange and$cyan 'sudo blkid'$orange will list your drives.$cyan 'sudo'$orange is needed with
   the blkid command in order to refresh the state - I don't know why.
$green
   You can open a new terminal window to do this as you read these instructions.
$orange
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
choose "emq"
read choice
case $choice in
q|Q) exit 0 ;; m|M) back2main ;; 
esac

clear
echo -e "
########################################################################################

    Once you have the drive name, we need to open the$cyan fdisk$orange utility and start from 
    scratch, wiping the partitions.
$green
             sudo umount -f /dev/sdb
$orange
    You may not need the '-f'force directive, but it's there anyway. Note it says
    'umount' not 'u${cyan}n${orange}mount'.             

    Only after the drive is unmounted can we perform fdisk operations...
$green
             sudo fdisk /dev/sdb
$orange    
    Now hit$cyan 'm'$orange if you want to see options or$red q$orange to quit, but for simplicity, just
    follow along...

    Hit$cyan g$orange <enter>$cyan w$orange <enter>
$orange
    This will write a new partition to the drive and exit fdisk. All the data would now 
    be lost on the drive, but it still needs to be formatted.

########################################################################################
"
choose "emq"
read choice
case $choice in
q|Q) exit 0 ;; m|M) back2main ;; 
esac
clear
echo -e "
########################################################################################
    
    At this point, if you return to the Bitcoin installation and select 'external'
    drive, Parmanode is likely to detect the drive now as normal.

    If you want to continue to manually do it, great...

########################################################################################
"
choose "emq"
read choice
case $choice in
q|Q) exit 0 ;; m|M) back2main ;; 
esac
clear ; echo -e "
########################################################################################

    The next thing to do is to format the drive to ext4 file system. 

    I suggest you do$cyan 'lsblk'$orange and $cyan 'sudo blkid'$orange again, just to be 
    sure there are no changes to the drive names.

    Then, format the drive...
$green
    sudo mkfs.ext4 -F -L \"parmanode\" /dev/sdb
$orange
    Remember to put the right name, don't just blindly copy /dev/sdb

    This will format the drive to the ext4 file system (standard for Linux), and at
    the same time will label the drive to \"parmanode\".

########################################################################################
"
choose "emq"
read choice
case $choice in
q|Q) exit 0 ;; m|M) back2main ;; 
esac
clear
echo -e "
########################################################################################

    This will now surely be detected by Parmanode, so you can import the drive 
    without issues. But you can continue with super manual tweaks...

########################################################################################
"
choose "emq"
read choice
case $choice in
q|Q) exit 0 ;; m|M) back2main ;; 
esac

set_terminal_wide ; echo -e "

##############################################################################################################
$cyan
                                          FSTAB (BE CAREFUL)
$orange
    The next thing to do is to make an entry in /etc/fstab so that the drive mounts when the computer 
    reboots. Ths is not strictly necessary - sometimes the drive mounts anyway when you log in, but with
    the fstab entry, it will mount BEFORE you log in after a reboot. This is what you want if you need
    the computuer to continue syncing Bitcoin without your intervention in the event of an unexpected
    reboot.
$red
    I DO NOT RECOMMEND YOU TO DO THIS MANUALLY, IT IS DANGEROUS; ANY ERRORS CAN MAKE YOUR COMPUTER 
    UNRESPONSIVE LIKE A BRICK. THIS IS FOR INFORMATIONAL PURPOSES ONLY. IT'S BEST THAT PARMANODE DOES THIS 
    FOR YOU AUTOMATICALLY WHEN YOU IMPORT.
$orange 
    You first need the UUID, extracted from the$cyan 'sudo blkid'$orange command. Then the following line needs to be 
    typed out exactly (replace \$UUID with the actual string of the UUID, and any spaces where they 
    shouldn't be can break your computer; eg no space after that comma).
  $red  
    echo "UUID=\$UUID /media/$USER/parmanode ext4 defaults,nofail 0 2" | sudo tee -a /etc/fstab 
    $orange
    It's best if you back up this file '/etc/fstab' so that if your computer 'breaks' you can restore it
    in emergency boot up mode. Note, sometimes, just removing the external drive and rebooting can work if 
    your computer goes funny after this. Then, you can simply replace the new file with the backup.

##############################################################################################################
"
choose "emq"
read choice
case $choice in
q|Q) exit 0 ;; m|M) back2main ;; 
esac

set_terminal ; echo -e "
########################################################################################
$cyan 
                                    MOUNT POINT
$orange
    If the /media/$USER/parmanode/ directory doesn't exist, you need to create it
    manually in order to mount th drive there. 
$green
        sudo mkdir -p /media/$USER/parmanode 
$orange    
    You also need to make sure the mount point is 'owned' by the current user...
$green
        sudo chown $USER -R /media/$USER/parmanode/
$orange
########################################################################################
"
choose "emq"
read choice
case $choice in
q|Q) exit 0 ;; m|M) back2main ;; 
esac

set_terminal
echo -e "
########################################################################################
$cyan 
                                Mount the drive
$orange
$green
    sudo mount /dev/sdb/ /media/$USER/parmanode/
$orange 
    This mounts the drive to the correct location for Parmanode to function properly.
    
    If you set up the fstab file correctly,$green 'sudo mount -a'$orange will mount the drive.
    Rebooting will also do it. Otherwise, use the mount command above.
    
    If you detach and attach the drive, with the fstab file NOT correctly configured,
    AND, if the /media/$USER/parmanode/ directoiry exists, then the Linux auto-mount
    plug n play feature will probably mount to /media/$USER/parmanode${cyan}1$orange, causing
    pandamonium. If the fstab entry is correct, plug n play will mount to the correct
    location.

########################################################################################
"
choose "emq"
read choice
case $choice in
q|Q) exit 0 ;; m|M) back2main ;; 
esac

clear
echo -e "
########################################################################################
$cyan
                                    UUID
$orange 
    It's optional but you can add a line to the parmanode.conf file

    UUID=

    and fill in the UUID string.

########################################################################################
"
choose "emq"
read choice
case $choice in
q|Q) exit 0 ;; m|M) back2main ;; 
esac

clear
echo -e "
########################################################################################
$cyan
                              Bitcoin Data Directory  
$orange
    Make a directory for the bitcoin data on the external drive
$green
         sudo mkdir /media/$USER/parmanode/.bitcoin    
$cyan



                                   Make symlink
$orange
    If the directory $HOME/.bitcoin exists, it needs to be moved (backed up) or
    deleted.

    Then create a symlink from the default data directory on the internal drive to 
    the external drive...
$green
        cd ~ && ln -s /media/$USER/parmanode/.bitcoin .bitcoin
$orange
########################################################################################
"
choose "emq"
read choice
case $choice in
q|Q) exit 0 ;; m|M) back2main ;; 
esac

clear
echo -e "
########################################################################################
$cyan
                        Parmanode.conf drive setting
$orange
    Finally, enter the external drive choice for bitcoin in the parmanode.conf
    directory.
$green
        cd ~/.parmanode
        nano .parmanode.conf
$orange
    This will open the nano text editor. If you see 'drive=internal', delete 
    such a line. If you don't see 'drive=external' then add that line, and save and
    exit.

########################################################################################
"
choose "emq"
read choice
case $choice in
q|Q) exit 0 ;; m|M) back2main ;; 
esac
clear ; echo -e "
########################################################################################
$cyan
                                bitcoin.conf 
$orange
    Finally, inside the external drive bitcoin data directory, create a file called
    bitcoin.conf
    
    In it add these lines...
$green
        server=1
        daemon=1
        rpcport=8332
        txindex=1
        blockfilterindex=1

        zmqpubrawblock=tcp://127.0.0.1:28332
        zmqpubrawtx=tcp://127.0.0.1:28333

        whitelist=127.0.0.1
        rpcbind=0.0.0.0
        rpcallowip=127.0.0.1
        rpcallowip=10.0.0.0/8
        rpcallowip=192.168.0.0/16
        rpcallowip=172.0.0.0/8
        
        rpcuser=parman
        rpcpassword=parman
$orange
    You can change the username and password to anything you want.

    Finally, you can start bitcoin from the Parmanode menu.

########################################################################################
"
choose "emq"
read choice
case $choice in
q|Q) exit 0 ;; m|M) back2main ;; 
esac
}