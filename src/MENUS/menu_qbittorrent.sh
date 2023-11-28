function menu_qbittorrent {
while true ; do 
set_terminal ; echo -e "
########################################################################################$cyan
                                QBittorrent Menu         $orange      
########################################################################################

              s)                     Start

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 
m|M) back2main ;;
q|Q|QUIT|Quit) exit 0 ;;
p|P) menu_use ;; 

s|S|start|Start|START|S|s)
check_SSH || return 0
start_qbittorrent || return 1
return 0 ;;

*) invalid ;;

esac
done
}

