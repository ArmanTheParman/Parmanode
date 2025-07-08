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

                few)$orange     Standard installation, v2.0.3

$red
                hfsp)$orange    Newer release v2.1.6  $yellow(Stable, but limited 
                                               testing with Parmanode)
$red
                yolo)$orange    Latest version on the BTCPay GitHub master branch
                                               $yellow(expect bugs)
$orange
                rekt)$orange    Manually enter the version you want
                                               $yellow(Reckless) 
$orange
########################################################################################
"
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
else choice=hfsp 
fi

case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
few)
export btcpay_version_choice="v2.0.3"
parmanode_conf_add "btcpay_version=$btcpay_version_choice"
break
;;
hfsp)
export btcpay_version_choice="v2.1.6"
parmanode_conf_add "btcpay_version=$btcpay_version_choice"
break
;;
yolo)
export btcpay_version_choice=master
parmanode_conf_add "btcpay_version=latest"
break
;;
rekt)
set_terminal ; echo -e "
########################################################################################

    Please type the version you want in the format$cyan v.x.xx.x $orange

    Parmanode is not going to check the validy or for typos so type carefully.

########################################################################################
"
read btcpay_version_choice
export btcpay_version_choice
parmanode_conf_add "btcpay_version=$btcpay_version_choice"
break
;;
*)
invalid
;;
esac
done

}