function choose_bitcoin_version_mac {
while true ; do
set_terminal  ; echo -e "
########################################################################################

    $green
    You have choices for installing Bitcoin with Parmanode... $orange


$cyan    1)$bright_blue    Bitcoin Knots version $knotsversion $orange

$cyan    2)$orange    Bitcoin QT version $version

$cyan    3)$red    Bitcoin in Docker (bundled with BTCPay)$orange 

            This is a new addition to Parmanode: You can opt to install Bitcoin 
            AND BTCPay Server together in a Docker container. You'll have all the 
            same menu options in Parmanode, but you won't have the Bitcoin-QT GUI pop-up. 
            Docker needs to be running for Bitcoin to be running.

$green

    What'll it be?

$cyan                   1)$green     All the cool kids are running Knots

$cyan                   2)$orange     Bitcoin Core

$cyan                   3)$red     Bitcoin Core inside BTCPay Docker Container

$orange
########################################################################################
"
choose xpmq ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;

2)
export btcdockerchoice=no
export bitcoin_compile="false"
break
;;
1)
parmanode_conf_add "bitcoin_choice=knots"
export knotsbitcoin="true" ; export version="Knots" ; export bitcoin_compile="false" 
export btcdockerchoice=no
break
;;
3)
export btcdockerchoice=yes
export bitcoin_compile="false"
break
;;
"")
continue ;;
*)
invalid
;;
esac
done


}