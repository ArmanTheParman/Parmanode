function select_drive_ID {

set_terminal_high

while true ; do     #while 1

case $OS in 
Linux)
lsblk
echo "Enter the identifier of the disk to be formatted (e.g. \"sdb\", \"sdc\", \"sdd\"." 
echo "Do not include partition numbers. Eg. don't type \"sdb1\" or \"sdb2\", just \"sdb\"):
echo "It is CASE SENSITIVE!"
" 
;;
*)
diskutil list
echo "Enter the identifier of the disk to be formatted (e.g. disk2 or disk3): " 
echo "Do not include partition numbers. Eg. don't type disk2s1 or disk2s2, just disk2:"  
;;
esac

read disk 

    if [[ $disk == "sda" || $disk == "disk0" ]] ; then #OS considered
        echo "This could be a system drive. Be careful and check. If you're sure, then"
        echo "type (yolo) and hit <enter>, or (x) to try again, (p) to return, (q) to quit."
        echo ""
        read choice
        case $choice in q|Q|Quit|QUIT) exit 0 ;; p|P) return 1 ;;
        yolo|Yolo|YOLO) true ;; x|X) continue ;; *) invalid ; continue ;; 
        esac
    fi

export disk

case $OS in
Linux)

    if [[ $disk =~ ^sd[a-z] ]]
    then
        set_terminal_high
        sudo fdisk -l | grep "$disk" 
        echo -e "
########################################################################################        

    Take a look above at the alternative output and check it really is the drive 
    you want to format.
$cyan
                               (y)$orange      Yes
$cyan
                               (n)$orange      No, try again.
$red
                               (q)$orange      Quit

########################################################################################
"        
choose "xmq"
read choice
    case $choice in
    q|Q) exit ;; m|M) back2main ;; y|yes) return 0 ;; n|NO|No|no) continue ;;
    *) invalid ;;
    esac

    else #regex else
        set_terminal_high
        echo -e "
########################################################################################

    Your entry does not match the pattern$green 'sd'$orange followed by a letter, which is the
    convention for SSD drives (you really should be using one of those, or something
    better).

    If you have a non-standard drive, you may have a name with a different pattern. 

    You can continue if you are sure you know what you are doing. 

########################################################################################

Hit$cyan <enter>$orange to abort, or type$red yolo$orange to proceed."
read choice

        if [[ $choice == "yolo" ]] ; then return 0 ; fi
        if [[ $choice == "" ]] ; then return 1 ; fi
        invalid 
        continue
    fi #regex fi

;;

Mac)
    if [[ $disk =~ ^disk[1-9] ]] ; then
    set_terminal_high
    diskutil list
echo -e "
########################################################################################        

    Take another look above and check $disk is really is the drive you want to
    format.
$cyan
                               (y)$orange      Yes
$cyan
                               (n)$orange      No, try again
$red
                               (q)$orange      Quit

########################################################################################
"        
choose "x"
read confirm
        if [[ $confirm == "y" ]] ; then return 0 ; fi
        if [[ $confirm == "n" ]] ; then continue ; fi
        if [[ $confirm == "q" ]] ; then exit 0 ; else invalid ; continue ; fi
        

    else # part of regex if
        
        set_terminal_high
        echo -e "
########################################################################################

    Your entry does not match the pattern 'disk' followed by a number.

    This requirement is a precaution. If you have a non-standard drive, you 
    may have a name with a different pattern. You can override this requirement
    if you are sure you know what you are doing. 

########################################################################################

Hit$cyan <enter>$orange to abort, or type$red yolo$orange to format the drive."

        read choice
        if [[ $choice == "yolo" ]] ; then return 0 ; else return 1 ; fi
    fi #regex fi ending
;;
esac # end case Linux vs Mac
done # end while 1
return 0
}
