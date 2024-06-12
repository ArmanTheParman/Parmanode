function btcpay_install_preamble2 {
while true ; do
set_terminal ; echo -e "
########################################################################################


    To make BTCPay Server work on Macs, some weird workarounds are needed. Not my 
    fault, it's Apple's fault.

    The BTCPay container will be built together with Bitcoin Core in the same
    container. The relevant data directories inside the container will be mounted
    to the appropriate directories on the Mac. This way, changes to files inside or 
    outside are mirrored, and even if you disconnect or delete the container, you 
    still keep the data on the Mac (or the external drive if you choose that). 
    Restarting the computer should start the containers, but you might need to set
    up Docker Desktop to start automatically for that to work.
$cyan
    Parmanode will now do the following if you proceed...

$cyan        1)$orange Partially install Bitcoin on the Mac (mainly to prepare the directories)    

$cyan        2)$orange Install BTCPay Server in a Docker Container

$cyan        3)$orange Download Parmanode in the container, and install Bitcoin there

$cyan        4)$orange Configure all the menus and apps so everything still works

$cyan        5)$orange You don't have to do anything difficult, just answer questions that
           pop up on the screen from time to time.
$blinkon
     PROCEED?$blinkoff
   $green 
                     y)      Hell yeah, this is great
$red
                     n)      Nah

$orange
########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
quit|Q|q) exit ;; p|P) return 1 ;; m|M) back2main ;;
y)
return 0
;;
n)
return 1
;;
*)
invalid
;;
esac
done
}