function install_raid {

if [[ $OS == Mac ]] ; then no_mac ; return 1 ; fi

while true ; do
set_terminal_custom 48 ; echo -e "
########################################################################################
$cyan
                                  R   A   I   D
$orange
    THIS SOFTWARE ADD-ON IS NOT FREE. YOU CAN TEST IT OUT FOR FREE, BUT IF YOU 'USE'
    IT (YOU DECIDE WHAT IS 'USE') THEN PLEASE CONTRIBUTE$green 20,000 SATS $orange- CHEAP AF.      
    You can give more if you think it is deserved ;)
$bright_blue
        https://armantheparman.com/donations
$orange
    RAID stands for Redundant Array of Independent Disks. There are various types, 
    each with their advantages and disadvantages. This Parmanode add-on offers 
    to help you setup either RAID-0 or RAID-1
$green
    RAID-0 $orange
    This allows you to have two dives connected which act as one single drive.
    Handy if you have multiple small drives that can all contribute towards storage
    for a Bitcoin node.
$green
    RAID-1 $orange
    This allows you to have two drives that mirror each other, allowing for
    redundancy and data protections. When mounted, it will appear that you have one
    drive connected. Each time you modify the contents, the data will be stored
    identically on both disks. If the two drives are different in size, both will
    only be able to store the capacity of the smaller drive.
$green
    RAID-2 to 6 and 10 $orange
    Look it up. Internet. Parmanode does not support these types for now.
$cyan
    YOU HAVE CHOICES... $orange

$green                          0)$orange       RAID 0

$green                          1)$orange       RAID 1

$green                          p)$orange       Get out of here

########################################################################################
" 
choose "xpmq" ; read choice ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; m|M) back2main ;;
0)
do_raid_0 || return 1
;;
1)
debug "start 1)"
do_raid_1 || return 1
debug "end 1)"
;;
*)
invalid
;;
esac
done

}