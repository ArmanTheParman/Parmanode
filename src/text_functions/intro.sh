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

            1) Linux (including Pi4) and Mac (Not available for Windows yet)

                   - Debian and Ubuntu Linux systems supported, including Mint.
                   - Other Linux distributions have not been tested yet.

            2) CPU Architecture:

                   - AMD/Intel 64 architecture (x86-64) 
                   - or M1/M2 Mac chip
                   - Raspbery Pi 32 or 64 bit

            3) An ext drive (1 Tb) OR and internal drive with spare capacity

            4) Users must not hold ANY shitcoins. Honesty system.
            
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
"Free Ross"|"free ross"|"free Ross") hide_messages_add "intro" "1" ; break ;;
"") break ;;

esac ; done ; fi ; return 0
}

