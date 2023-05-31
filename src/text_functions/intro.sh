function intro {
. $HOME/.parmanode/hide_messages.conf >/dev/null
set_terminal_high
if [[ $message_intro != "1" ]] ; then 
while true
do
echo "
########################################################################################

    Welcome to PARMANODE, an easy AF way to install and run Bitcoin on your computer 
    with the option of additional related programs.

########################################################################################


    Requirements:

            1) Debian/Ubuntu/Mint Linux, Mac (including Raspberr Pi 4)
            
             (Not available for Windows yet)

            2) recommended: An ext drive (1 Tb) OR internal drive with spare capacity

            3) Users must not hold ANY shitcoins. Honesty system.
            
            5) Free: 
                   - Donations appreciated
                   - Yes, the code is open source, MIT licence, like Bitcoin


    To report bugs:
                   - armantheparman@protonmail.com
                   - Telegram chat: https:/t.me/parmanode


    To hire personal assistance to setup:
                   - email armantheparman@protonmail.com
    

########################################################################################

Hit <enter> to continue, or (q) to quit, then <enter>.

If you hold shitcoins, please hit (s) - be honest!

To hide this screen next time, type \"Free Ross\" then <enter>.
"
read choice
case $choice in 
s|S) dirty_shitcoiner ; continue ;;
q|Q|QUIT|Quit|quit) exit 0 ;;
"Free Ross"|"free ross"|"free Ross") hide_messages_add "intro" "1" ; set_terminal ; break ;;
"") break ;;

esac ; done ; fi ; return 0
}

