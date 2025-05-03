function intro {
if [[ -f $HOME/.parmanode/hide_messages.conf ]] ; then
. $HOME/.parmanode/hide_messages.conf >$dn
fi

set_terminal_high
if [[ ${message_intro} != "1" ]] ; then 
while true
do
echo -e "$orange
########################################################################################

           $cyan                  P  A  R  M  A  N  O  D  E    $orange

########################################################################################

    Welcome to$red PARMANODE$orange, an easy AF way to install and run Bitcoin on your desktop
    computer. Parmanode is Free Open Source Software (FOSS).


    Requirements:

            1) Debian based$green Linux$orange PC or Pi, or$green MacOS$orange > version 10.9
            
            2) An external OR internal drive (2 Tb SSD recommended, 1 Tb will do)
$red$blinkon
            3) Users must not hold ANY shitcoins! (Honesty system)
$blinkoff$orange
$bright_blue
    To report bugs:
                   - armantheparman@protonmail.com

                   - Telegram chat: https:/t.me/parmanode
$orange
########################################################################################

    Hit$cyan <enter>$orange to continue, or$cyan (q)$orange to quit, then <enter>.

    If you hold shitcoins, please hit$cyan (s)$orange - be honest!

    To hide only this screen next time, type$pink EndTheFed$orange then <enter>.
"
read choice ; set_terminal
case $choice in 
s|S) dirty_shitcoiner ; continue ;;
q|Q|QUIT|Quit|quit) exit 0 ;;
endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "intro" "1" ; set_terminal ; break ;;
*) break ;; #invalid won't work here, there'll be a never ending loop
esac ; done ; fi ; set_terminal ; return 0
}

