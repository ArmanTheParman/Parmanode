function get_btcdockerchoice {
while true ; do
set_terminal  ; echo -e "
########################################################################################


    On a Mac you have two general choices for installing Bitcoin with Parmanode.

$cyan    1)$orange    You can install the Bitcoin-QT program, which has a graphical interface 
          (GUI). It's better to minimise and not use the GUI. Just use the Parmanode 
          menus to manage it. 

          This has been the standard way for a while, but it means you$red cannot 
          install BTCPay server on the Mac$orange - that's the only downside. It's a Mac
          thing - they decided to make Docker networking too restrictive to make
          it work.

          With this option,$bright_blue you can later choose Bitcoin Core or Bitcoin Knots. $orange

$cyan    2)$orange    This is a new addition to Parmanode: You can instead opt to install Bitcoin 
          AND BTCPay Server together in a Docker container. You'll have all the 
          same menu options in Parmanode, but you won't the the Bitcoin-QT GUI pop-up. 
          Parmanode.

$bright_blue          Bitcoin Knots is not available yet with this option.$orange

    What'll it be?
$green
                   1)     Regular way, just install Bitcoin normally
$cyan
                   2)     Both. I want Bitcoin AND BTCPay in Docker. 

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
export btcdockerchoice=yes
break
;;
*)
invalid
;;
esac
done


}