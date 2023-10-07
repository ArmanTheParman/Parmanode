function pi4_warning {

set_terminal ; echo "
########################################################################################

                         W A R N I N G: Pi4 will be SLOW

    It is not recommended that you run Mempool on a Pi4. During testing, it installed, 
    it worked for a bit, but the device rapidly came to a stall, and was completely
    unrepsonsive, requiring a hard reboot. However, upon restarting, it was working
    fine. Be warned. 

    To ignore my sage advice, type yolo, to proceed with the install. Otherwise, 
    hit <enter> to abort.

########################################################################################                
"
read choice
case $choice in yolo|YOLO|Yolo) return 0 ;; *) return 1 ;; esac 

}