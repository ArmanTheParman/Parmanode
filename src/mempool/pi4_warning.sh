function pi4_warning {

set_terminal ; echo "
########################################################################################

                         W A R N I N G: Pi4 will be SLOW

    It is not recommended that you run Mempool on a Pi4. It will install, it will
    work for a bit, but the device rapidly comes to a stall, and can become completely
    unrepsonsive. So don't do it.

    To ignore my sage advice, type yolo, to proceed with the install. Otherwise, 
    hit <enter> to abort.

########################################################################################                
"
read choice
case $choice in yolo|YOLO|Yolo) return 0 ;; *) return 1 ;; esac 

}