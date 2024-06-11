function choose_btcpay_version {
unset btcpay_version_choice
while true ; do
set_terminal ; echo -e "
########################################################################################


    BTCPay is dependent of various other software. Whenever BTCPay updates to a newer
    version, Parmanode does not automatically incorporate it because sometimes things
    break.

    From time to time, I will thoroughly test BTCPay newer versions and update what
    is offered here.

    For the time being, the latest I have tested is$green v1.12.5$orange

    If you want the latest version available, untested by me, and just see what 
    happens, you are welcome to do that.
$green

                    s)       Standard installation, v1.12.5
$red
                    yolo)    Lates version on the BTCPay GitHub master branch
$orange

########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
s)
export btcpay_version_choice="v1.12.5"
;;
yolo)
export btcpay_version_choice=master
break
;;
*)
invalid
;;
esac
done

}