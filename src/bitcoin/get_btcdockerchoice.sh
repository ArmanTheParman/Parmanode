function get_btcdockerchoice {
while true ; do
set_terminal  ; echo -e "
########################################################################################

    On a Mac you have two general choices for installing Bitcoin with Parmanode.

    1)    You can install the Bitcoin-QT program, which has a graphical interface.
          Despite the GUI, you should still use the Parmanode menus to manage it. 

          This has been the standard way for a while, but it means you$red cannot 
          install BTCPay server on the Mac$orange - that's the only downside. It's a Mac
          thing - they decided to make Docker networking too restrictive, causing
          great difficulties to get BTCPay to communicate with Bitcoin external to 
          the container.


    2)    You can opt to install Bitcoin AND BTCPay Server together in a Docker
          container. You'll have all the same menu options in Parmanode, but you
          won't the the Bitcoin-QT GUI pop-up. This is a new addition to Parmanode.

    What'll it be?
$green
                   r)     Regular way, just install Bitcoin normally
$cyan
                   b)     Both. I want Bitcoin AND BTCPay in Docker. 
$orange
########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;

r)
export btcdockerchoice=no
break
;;
b)
export btcdockerchoice=yes
break
;;
*)
invalid
;;
esac
done


}