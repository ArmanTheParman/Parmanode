function format_ext_drive {
clear
echo "
YOU ARE ABOUT TO FORMAT THE DRIVE! All data on the drive will be erased.

If you skip formatting, make sure there is enough free capacity on the drive before
running Bitcoin.

Hit \"y\" to format the external drive

or

Hit <enter> or anything else to go back, or q to quit.

"
read choice

if [[ $choice != 'y' ]] ; then return 0 ; fi

clear

echo "
###################################################################################
   IT IS EXTREMELY IMPORTANT TO PAY ATTENTIONS HERE...
###################################################################################
You must make sure you select the correct drive from the following list. One way
to determine which drive is the one you need to select is knowing the size of the
drive (and matching it to what is stated in the list). 

That clue can help, but is not always the case, eg. if you have two drives with the
same size.

THE WORST THING THAT CAN HAPPEN IS YOU CHOOSE THE WRONG DRIVE AND IT GETS FORMATTED,
AND YOU LOSE YOUR DATA. YOU COULD EVEN WIPE ALL THE DATA FROM YOUR COMPUTER IF YOU 
SELECT THE WRONG DRIVE. IF YOU ARE UNSURE, STOP, AND HIT Control-c

"
read -p "Hit enter to continue and see the list..."

clear
diskutil list
read -p "Enter the identifier of the disk to be formatted (e.g. disk2 or disk3): " disk

clear
diskutil info $disk
read -p "Are you sure you want to format $disk? (y/n) " answer

if [[ $answer != "y" ]] ; then return 0 ; fi #return if user doesn't select y

clear
diskutil eraseDisk exFAT "parmanode" $disk

read -p "Next, a directory structure will be created on the drive. Hit <enter> to continue." null

if [[ -d /Volumes/parmanode/bitcoin_data/ ]]
then
    return 0
else
    cd /Volumes/parmanode
    mkdir bitcoin_data
    return 0
fi

}