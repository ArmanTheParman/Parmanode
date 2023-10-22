function ssl_port_change_fulcrum {    #called by fulcrum_to_remote function

while true ; do
set_terminal ; echo "
########################################################################################

                                    SSL port

    The standard port that Fulcrum server will use to communicate with wallets is
    50002. If you have more than one Fulcrum server, this will cause mass confusion
    and pandamonium. You can use port 50003 instead, but do remember to put the
    correct port in your wallet.

            2)           Change to 50002 

            yolo)        Change to 50003

            x)           Don't touch anything (skip)

########################################################################################
"
choose "xpq" ; read choice

case $choice in 

q|Q|QUIT|Quit) exit 0 ;; 

p|P) return 1 ;; 

2) 
    edit_ssl_port_fulcrum_indocker 50002
    break
;;

yolo|YOLO|Yolo)

    edit_ssl_port_fulcrum_indocker 50003
    break
;; 

x|X) 
break ;;

*) 
invalid ;; 
esac

done

return 0
}