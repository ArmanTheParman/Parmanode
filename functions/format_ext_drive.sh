function format_ext_drive {
	
set_terminal

#Warn the user to pay attention.
format_warnings
if [ $? == 1 ] ; then return 1 ; fi # return 1 means user skipped formatting.
select_drive_ID

#User has typed sd? , or overidden the requirement, to proceed. All failures to this point return 1.

set_terminal

unmount_the_drive

dd_wipe_drive   #function defined at the end of the file.

#partition function written below
partition_drive 

#Format the drive

sudo mkfs.ext4 -F /dev/$disk
enter_continue

#Mounting
sudo mkdir /media/$(whoami)/parmanode 2>/dev/null    #makes mountpoint
sudo mount /dev/$disk /media/$(whoami)/parmanode
sudo chown -R $(whoami):$(whoami) /media/$(whoami)/parmanode
sudo e2label /dev/$disk parmanode

#Extract the *NEW* UUID of the disk
UUID=$(sudo blkid /dev/$disk | grep -o 'UUID="[^"]*"' | grep -o '"[^"]*"')
UUID_temp=$(echo "$UUID" | sed 's/"//g')
UUID=$UUID_temp

#Write to fstab 
if grep -q $UUID /etc/fstab 
	    then
        echo "unable to write to fstab. You will have to manually mount the drive each time you boot up." 
        else 
	    echo "UUID=$UUID /media/$(whoami)/parmanode ext4 defaults 0 2" | sudo tee -a /etc/fstab > /dev/null 2>&1
fi

#confirmation output.
echo "Some more cool computer stuff happened in the background."
enter_continue # pause not required as all the above code has no output
parmanode_conf_add "UUID=$UUID"
set_terminal
echo "
#######################################################################################

    If you saw no errors, then the $disk drive has been wiped, formatted, mounted, 
    and labelled as \"parmanode\".
    
    The drive's UUID, for reference, is $UUID.

    A drive's UUID (Universally Unique Identifier) is a unique identifier assigned 
    to a storage device (like a hard drive, SSD, or USB drive) to distinguish it 
    from other devices. 
    
    Stay calm: YOU DON'T HAVE TO REMMEBER IT OR WRITE IT DOWN.  

    The /etc/fstab file has been updated to include the UUID and the drive should 
    automount on reboot.

########################################################################################
"
enter_continue

return 0

}

########################################################################################

function partition_drive {


sdrive="/dev/$disk"    #$disk chosen earlier and has the pattern sdX

# Check if the drive exists
if [ ! -e "$sdrive" ] ; then
    set_terminal
    echo "Drive $sdrive does not exist. Exiting."
    enter_continue
    exit 1
fi

# Create a new GPT partition table and a single partition on the drive
# interestingly, you can plonk a redirection in the middle of a heredoc like this:
sudo fdisk "$sdrive" <<EOF >/dev/null 
g
n
1


w
EOF
# The fdisk command makes the output white which I don't like.
# Not sure if anyone knows a better fix. I kind of prefer to to hide the
# standard output as it can be important to some users.

echo "A new GPT partition table and a single partition have been created on $drive."

return 0
}

function select_drive_ID {

read -p "Hit <enter> to see the list..."

set_terminal

lsblk

echo "Enter the identifier of the disk to be formatted (e.g. \"sdb\", \"sdc\", \"sdd\"." 
echo "Do not include partition numbers. Eg. don't type sdb1 or sdb2, just sdb):
" 
read disk

    if [[ $disk == "sda" ]]
        then
            echo "You must be crazy. Parmanode refuses to format the drive that runs your operating system.
            " 
            read "Hit <enter> to go back."
            return 1
    fi

    if [[ $disk =~ ^sd[a-z] ]]
        then
        set_terminal
        sudo fdisk -l | grep "$disk" 
        echo -e "
########################################################################################        

    Take a look above at the alternative output and check it really is the drive 
    you want to format.

                               (y)      Yes

                               (n)      No

########################################################################################
"        
choose "x"
read confirm
        if [[ $confirm != "y" ]] ; then return 1 ; fi
        else
        set_terminal
        echo "
########################################################################################

    Your entry does not match the pattern "sd" followed by a letter.

    This requirement is a precaution. If you have a non-standard drive, you 
    may have a name with a different pattern. You can override this requirement
    if you are sure you know what you are doing. 

########################################################################################

Hit <enter> to abort, or type "yolo" to destroy the drive."

read choice
        if [[ $choice != "yolo" ]] ; then return 1 ; fi
        fi

return 0
}

########################################################################################

function format_warnings {
echo "
########################################################################################

    YOU ARE ABOUT TO FORMAT THE DRIVE! All data on the drive will be erased.

    If you skip formatting, make sure there is enough free capacity on the drive 
    before running Bitcoin.
                
                         (y)     format drive

                         (s)     skip formatting
    
			 
    If skipping, make sure your drive is formatted and mounts to: 
			 
	                 /media/$(whoami)/parmanode
    
########################################################################################

"
choose "xq"

read choice
set_terminal
if [[ $choice == "s" ]] 
        then return 1 #skips formatting.
	else
	#exit if (y) not selected
	if [[ $choice != 'y' ]] ; then return 1 ; fi 
fi

set_terminal
echo "
########################################################################################
########################################################################################
                IT IS EXTREMELY IMPORTANT TO PAY ATTENTIONS HERE...
########################################################################################
########################################################################################

    You must make sure you select the correct drive from the following list. One way
    to determine which drive is the one you need to select is knowing the size of the
    drive (and matching it to what is stated in the list). 

    That clue can help, but is not always the case, eg. if you have two drives with 
    the same size.

    THE WORST THING THAT CAN HAPPEN IS YOU CHOOSE THE WRONG DRIVE AND IT GETS 
    FORMATTED, AND YOU LOSE YOUR DATA. YOU COULD EVEN WIPE ALL THE DATA FROM YOUR 
    COMPUTER IF YOU SELECT THE WRONG DRIVE. IF YOU ARE UNSURE, STOP, AND HIT Control-c

########################################################################################
########################################################################################

"
return 0
}

########################################################################################

function dd_wipe_drive {
echo "
########################################################################################

    \"Craig Wright is a liar and a fraud. \" will be used to write over and erase
    the disk.

                       <enter>      Proceed

			 (0)        Write zeros (VERY slow, hours even)

		         (r)        Random data (Even SLOWER!), but best for privacy

		         (c)        Choose a custom string

########################################################################################
"
choose "xq"

read choice

while true
do
set_terminal

case $choice in

	0)
	    please_wait
            sudo dd if=/dev/zero bs=10M count=100 status=progress ; sync ; return 0 
	    ;;

	r|R)   
	    please_wait
            sudo dd if=/dev/urandom bs=10M count=100 status=progress ; sync ; return 0 
	    ;;

        c|C) 

            echo "
########################################################################################

    Please enter your preferred string. Remember to put a space at the end so the 
    repetitions have separation:

########################################################################################
" 
           read string

           echo "
Your string is: $string 
"
           break 
          ;;
	q|Q|quit|Quit|QUIT)
	  exit 0
	  ;;

        *)
           string="Craig Wright is a liar and a fraud. " #default string if no customised string selected
	   break
           ;;
esac    
done
#break point from while
please_wait
#"status=progress" won't work becuase of the pipe, but leving it in for future reference.
yes "$string " | sudo dd iflag=fullblock of=/dev/$disk bs=1M count=1000 status=progress ; sync 
    
return 0
}

########################################################################################

function unmount_the_drive {
set_terminal
echo " 
Please wait a few seconds for the drive to unmount ... 
"
for i in $(sudo lsblk -nrpo NAME /dev/sdb) ; do sudo umount $i >/dev/null 2>&1 ; done

#redunant but harmless...
sudo umount /dev/$disk >/dev/null 2>&1

sleep 3
set_terminal
return 0
}
