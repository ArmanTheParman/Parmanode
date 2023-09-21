function intro {

if [[ -f $HOME/.parmanode/hide_messages.conf ]] ; then
. $HOME/.parmanode/hide_messages.conf >/dev/null
fi

set_terminal_high
if [[ ${message_intro} != "1" ]] ; then 
while true
do
echo "
########################################################################################

                            P  A  R  M  A  N  O  D  E

########################################################################################

    Welcome to PARMANODE, an easy AF way to install and run Bitcoin on your computer 
    with the option of additional related programs. 
    
    Everything is Free Open Source Software.

    Requirements:

            1) Debian based Linux (includes Ubuntu/Mint) PC/Pi, or Mac
            
                          (Not available for Windows yet)

            2) Recommended: An external OR internal drive (1 Tb required)

            3) Users must not hold ANY shitcoins! Honesty system.


    To report bugs:
                   - armantheparman@protonmail.com
                   - Telegram chat: https:/t.me/parmanode

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

