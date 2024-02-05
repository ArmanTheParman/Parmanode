function manual_cc {
cd $hp/coldcard >/dev/null
if [[ $OS == Linux ]] ; then
message="$bright_blue(right-click-paste tends to work better on Linux
                                   than keyboard shortcuts, don't ask me why)$orange"
fi

set_terminal ; echo -e "
########################################################################################

    If Parmanode doesn't have the latest version available yet, not a problem, this
    wizard can guide you through to get the latest version.

########################################################################################
"
enter_continue

while true ; do
unset choice_file
set_terminal ; echo -e "
########################################################################################

    Please copy the exact file name you want from this website:
$green
    https://coldcard.com/downloads 
$orange
    Then paste it in the terminal $message

    Then hit$green <enter>$orange

########################################################################################
"
read choice_file ; export choice_file

set_terminal ; echo -e "
########################################################################################

    You have chosen the file:
$cyan
    $choice_file 
$orange
   If this looks right, type$green yes$orange then$green <enter>$orange to proceed.
   
   To try again just hit$red <enter>$orange

########################################################################################
"
read choice
case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; M|m) back2main ;;
n) continue ;;
yes) break ;;
*) invalid ;;
esac
done
#file should be held in $choice_file
}