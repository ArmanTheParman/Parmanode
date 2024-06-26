function choose_btcpay_version {
unset btcpay_version_choice
while true ; do
if [[ $btcpayinstallsbitcoin != "true" ]] ; then
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
                    hfsp)    Manually enter the version you want

########################################################################################
"
choose xpmq ; read choice ; set_terminal
else
choice=s
fi

case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
s)
export btcpay_version_choice="v1.12.5"
break
;;
yolo)
export btcpay_version_choice=master
break
;;
hfsp)
set_terminal ; echo -e "
########################################################################################

    Please type the version you want in the format v.x.xx.x

    Parmanode is not going to check the validy or for typos so type carefully.

########################################################################################
"
read btcpay_version_choice
break
;;
*)
invalid
;;
esac
done

}