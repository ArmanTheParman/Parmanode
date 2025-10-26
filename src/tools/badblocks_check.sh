function badblocks_check {
if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

set_terminal 44 88
printf "\e[41m$(printf ' %.0s' {1..88})"
printf "\n"
echo -e $reset
lsblk -p #-p adds the /dev/ prefix
printf "\n"
printf "\e[41m$(printf ' %.0s' {1..88})"
printf "\n"
echo -e "$reset$orange
    Please enter the drive ID you want to check for bad blocks.

    Note: this is read-only - it is not a destructive test. It is also very SLOW.
    You can leave it running, and open a new terminal window to continue using
    Parmanode while you wait for it to finish.
$cyan    
    Eg: /dev/sda or /dev/nvme0n1
$orange
    "
printf "\e[41m$(printf ' %.0s' {1..88})"
printf "\n$reset$orange"

read driveid </dev/tty

if ! [[ $driveid =~ ^/dev/ ]] ; then sww "Doesn't look like a valid drive ID. Must start with /dev/" ; return 1 ; fi
yesorno "Use $driveid?" || return 1

sudo badblocks -sv $driveid || sww

return 0
}