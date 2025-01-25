function rossisfree {

[[ -e $dp/.rossisfree.txt ]] || cat <<'EOF' >> $dp/.rossisfree.txt

         ____   ___  ____ ____    ___ ____    _____ ____  _____ _____ _ _ 
         |  _ \ / _ \/ ___/ ___|  |_ _/ ___|  |  ___|  _ \| ____| ____| | |
         | |_) | | | \___ \___ \   | |\___ \  | |_  | |_) |  _| |  _| | | |
         |  _ <| |_| |___) ___) |  | | ___) | |  _| |  _ <| |___| |___|_|_|
         |_| \_\\___/|____|____/  |___|____/  |_|   |_| \_|_____|_____(_(_)

EOF

if grep -q freeross $hm 2>$dn ; then return 1 ; fi

set_terminal
echo -e "
########################################################################################

$pink$blinkon
"
cat $dp/.rossisfree.txt
echo -e "$blinkoff $orange


########################################################################################


"
enter_continue "Type in$green EndTheFed$orange to dismiss message permanently"
case $enter_cont in EndTheFed|endthefed) echo "message_freeross=1" >> $hm ;; esac
return 0
}