function install_raid {

while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                  R   A   I   D
$orange
    RAID stands for Redundant Array of Independent Disks. There are various types, 
    each with their advantages and disadvantages. Parmanode offers to help you setup
    either RAID-0 or RAID-1
$green
    RAID-0 $orange
    This allows you to have two dives connected which act as one single drive.
$green
    RAID-1 $orange
    This allows you to have two drives that mirror each other, allowing for
    redundancy and data protections. When mounted, it will appear that you have one
    drive connected. Each time you modify the contents, the data will be stored
    identically on both disks. If the two drives are different in size, both will
    only be able to store the capacity of the smaller drive.
$green
    RAID-2 to 6 and 10 $orange
    Look it up. Internet.
$cyan
    YOU HAVE CHOICES... $orange

$green                          0)$orange       RAID 0

$green                          1)$orange       RAID 1

$green                          p)$orange       Get out of here

########################################################################################
" ; read choice ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; m|M) back2main ;;
0)
do_raid_0
;;
1)
do_raid_1
;;
*)
invalid
;;
esac
done

}