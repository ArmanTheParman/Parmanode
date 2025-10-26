function badblocks_check {
if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

set_terminal 49 88
printf "\e41m"
printf ' %.88s' {1..88}
printf "\n"
echo -e $reset$orange
lsblk
printf "\e41m"
printf ' %.88s' {1..88}
printf "\n"
echo -e "$reset$orange\n
########################################################################################

    Please enter the drive ID you want to check for bad blocks.

    Note: this is read-only - it is not a destructive test.
$cyan    
    Eg: /dev/sda or /dev/nvme0n1
$orange
    This will run in a TMUX window (backround). You can check on it by typing:
$cyan
    tmux attach -t badblocks
$orange
    from the terminal (not from withing Parmanode).

    You can leave the TMUX window open, but to exit it and leave the process running 
    in the background,$cyan type <control> b then d$orange. Go back in anytime with the 
    earlier command.

########################################################################################
"
read driveid </dev/tty

if ! [[ $driveid =~ ^/dev/ ]] ; then sww "Doesn't look like a valid drive ID. Must start with /dev/" ; return 1 ; fi
yesorno "Use $driveid?" || return 1

pn_tmux "sudo badblocks -sv $driveid" "badblocks"
return 0
}