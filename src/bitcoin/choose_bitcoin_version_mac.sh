function choose_bitcoin_version_mac {
while true ; do
set_terminal  ; echo -e "
########################################################################################

    $green
    You have choices for installing Bitcoin with Parmanode... $orange


            $cyan    k)$orange    Bitcoin Knots version $knotsversion (MacOS 13+) 

            $cyan  old)$orange    Bitcoin Knots version 28.1 (for older Macs) 

            $cyan  bqt)$orange    Bitcoin Core QT version $version  

            $cyan   bd)$red    Bitcoin Core in Docker (bundled with BTCPay)
            
$orange
########################################################################################
"
choose xpmq ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;

bqt)
export btcdockerchoice=no
export bitcoin_compile="false"
break
;;
old|k|"")
if [[ $choice == "old" ]] ; then #cose old knots...
    [[ $OS == "Mac" ]] && export knotsversion=29.1 && export knotsdate=20250903 && knotsmajor=29.x && knotsextension="zip" && coreexternsion="tar.gz"
else #chose new knots...
    [[ $MacOSVersion_major -gt "12" ]] || { yesorno "You need Mac Version 13 or greater to run this newer version of Knots. 
        Your system is:
$blue
$(sw_vers)
$orange
        Continue?" || continue ; 
        }
fi
parmanode_conf_add "bitcoin_choice=knots"
export knotsbitcoin="true" ; export version="Knots-$knotsversion" ; export bitcoin_compile="false" 
export btcdockerchoice=no
break
;;
bd)
export btcdockerchoice=yes
export bitcoin_compile="false"
break
;;
*)
invalid
;;
esac
done


}