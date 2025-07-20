function menu_nym {
    announce "Use the Start menu to find Nym and run it that way."
    return 0

#beginnings of a menu, but the idea  was abandoned, seems pointless for Nym.
set_terminal
echo "$orange
########################################################################################$cyan
                                  NYM VPN MENU$orange



$cyan
            s)                 Start
$cyan
            st)                Stop
$cyan
            str)               Store Account (enter mnemonic)
$cyan
$cyan
$cyan

########################################################################################"
choose xpmq ;  read choice 
}