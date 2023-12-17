function intro {
if [[ -f $HOME/.parmanode/hide_messages.conf ]] ; then
. $HOME/.parmanode/hide_messages.conf >/dev/null
fi

set_terminal_high
if [[ ${message_intro} != "1" ]] ; then 
while true
do
echo -e "
########################################################################################

           $cyan                  P  A  R  M  A  N  O  D  E    $orange

########################################################################################

    Welcome to PARMANODE, an easy AF way to install and run Bitcoin on your desktop
    computer. Parmanode is Free Open Source Software (FOSS).


    Requirements:

            1) Debian based Linux PC or Pi, or MacOS > 10.9
            
            2) An external OR internal drive (1 Tb SSD recommended)

            3) Users must not hold ANY shitcoins! (Honesty system)


    To report bugs:
                   - armantheparman@protonmail.com

                   - Telegram chat: https:/t.me/parmanode

########################################################################################

    Hit$cyan <enter>$orange to continue, or$cyan (q)$orange to quit, then <enter>.

    If you hold shitcoins, please hit$cyan (s)$orange - be honest!

    To hide this screen next time, type$pink \"Free Ross\"$orange then <enter>.
"
read choice ; set_terminal
case $choice in 
s|S) dirty_shitcoiner ; continue ;;
q|Q|QUIT|Quit|quit) exit 0 ;;
"Free Ross"|"free ross"|"free Ross") hide_messages_add "intro" "1" ; set_terminal ; break ;;
"") break ;;
esac ; done ; fi ; set_terminal ; return 0
}

