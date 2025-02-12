function menu_qrencode {

while true ; do
set_terminal ; echo -en "
########################################################################################
                                     QR Encode
########################################################################################


                       ${pink}QREncode is installed on your system.


$cyan
                    info)$orange          Info fo DIY QR codes
$cyan
                    pub)$orange           QR of your computer's SSH pubkey


########################################################################################
"
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
quit|Q|q) exit ;; p|P) return 1 ;; m|M) back2main ;;
info) qrencode_info ;;
pub) 
set_terminal_custom 50 100
echo "Public key..."
qrencode -t ANSIUTF8 "$(cat ~/.ssh/id_rsa.pub)"
enter_continue
;;

*) invalid ;;
esac
done
}

function qrencode_info {
set_terminal ; echo -en "
########################################################################################
                                  QREncode Info
########################################################################################
$orange
    To use qrencode command manually, the syntax is ...
$cyan
                        qrencode -t ANSIUTF8 \"some text\"
$orange
    You can also QR the contents of a file ...
$cyan
                        qrencode -t ANSIUTF8 \"\$(cat /path/to/file)\"
$orange
    Don't omit the \" 

########################################################################################
"
enter_continue
}