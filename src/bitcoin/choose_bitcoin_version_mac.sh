function choose_bitcoin_version_mac {
export version="27.1"
export knotsversion="27.1"
while true ; do
set_terminal  ; echo -e "
########################################################################################

    $green
    You have choices for installing Bitcoin with Parmanode... $orange


$cyan    1)$orange    Bitcoin QT version $version


$cyan    2)$bright_blue    Bitcoin Knots version $knotsversion $orange

$cyan    3)$orange    This is a new addition to Parmanode: You can opt to install Bitcoin 
          AND BTCPay Server together in a Docker container. You'll have all the 
          same menu options in Parmanode, but you won't have the Bitcoin-QT GUI pop-up. 
          Docker needs to be running for Bitcoin to be running.


    What'll it be?

$cyan                   1)$orange     Bitcoin QT

$cyan                   2)$bright_blue     All the cool kids are running Knots

$cyan                   3)$red     Bitcoin AND BTCPay in Docker

$orange
########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;

1)
export btcdockerchoice=no
break
;;
2)
parmanode_conf_add "bitcoin_choice=knots"
export knotsbitcoin="true" ; export version="Knots" ; export bitcoin_compile="false" 
export btcdockerchoice=no
break
;;
3)
export btcdockerchoice=yes
break
;;
*)
invalid
;;
esac
done


}