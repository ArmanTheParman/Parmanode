function ssl_port_change_fulcrum {    #called by fulcrum_to_remote function

while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                    SSL port
$orange
    The standard port that Fulcrum server will use to communicate with wallets is
    50002. If you have more than one Fulcrum server, this will cause mass confusion
    and pandamonium. You can use port 50003 instead, but do remember to put the
    correct port in your wallet.
$green
            2)$orange           Use 50002 
$red
            yolo)$orange        Change to 50003
$green
            x)$orange           Don't touch anything (skip)

########################################################################################
"
choose "xpmq" ; read choice

case $choice in 
m|M) back2main ;;

q|Q|QUIT|Quit) exit 0 ;; 

p|P) return 1 ;; 

2) 
    edit_ssl_port_fulcrum_inpodman 50002
    break
;;

yolo|YOLO|Yolo)

    edit_ssl_port_fulcrum_inpodman 50003
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