function menu_education {

while true ; do
set_terminal
echo -ne "
########################################################################################$cyan

                            P A R M A N O D E - Education $orange

########################################################################################

$cyan                    
                    mit)$orange      2018 MIT Lecture Series (With Tagde Dryja)
$cyan
                    w)$orange        How to connect your wallet to your node
$cyan
                    mm)$orange       Bitcoin Mentorship Info
$cyan
                    n)$orange        Six reasons to run a node (essay)
$cyan
                    s)$orange        Separation of money and state (essay)
$cyan
                    cs)$orange       Cool stuff ('Did you know?')
$cyan
                    crypt)$orange    How to change drive encryption password for
                              ParmAirGap computers.


########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;

    mit)
        mit_lectures
        ;;

    w|W)
        connect_wallet_info
        ;;
    mm|MM|mM|Mm)
        mentorship
        ;;
    n|N|node|Node)
        # the less function inside the custom less_function takes a variable to know which file to print.
        less_function "6rn"
        ;;
    s|S)
        less_function "joinus"
        ;;
    cs|CS|Cs)
        cool_stuff
        ;;
    crypt)
        pag_change_password
    ;;

    *)
        invalid 
        ;;

esac
done
return 0
}

function pag_change_password {
 

announce "This is instructions for how to change the drive encryption password for people who 
    purchased a ParmAirGap computer.

    If you don't have a ParmAirGap, that's ridiculous. You can get one here:
    $cyan
    https://parman.org
    $orange

    The ParmAirGap comes with LUKS encryption on the drive. There are 8 password 
    slots, one of them is generic and you should remove it. But before you do, you 
    should add then test your new password. After that, remove the original generic 
    one. Do it this way to not get locked out of your computer forever."

announce "To add a password, follow these steps:

    1. Open terminal
    2. lsblk (This command shows your drives)
    3. Identify your drive (it should be something like /dev/nvme0n1p2 or /dev/sda1)
    4. sudo cryptsetup luksAddKey /dev/yourdrive
    5. Follow the promtps to enter your old then new password (twice) - no errors means
       it worked.
    6. Reboot the machine and try the new password to make sure it works.
    7. Delete the old password with: sudo cryptsetup luksRemoveKey /dev/yourdrive
       You will be asked which password to remove."
}