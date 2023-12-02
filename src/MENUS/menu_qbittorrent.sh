function menu_qbittorrent {
while true ; do 
set_terminal ; echo -e "
########################################################################################$cyan
                                QBittorrent Menu         $orange      
########################################################################################

              s)               Start

              t)               Download Parman's ParmanodL OS Torrent file

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

t)
cd $HOME/parman_programs/
curl -LO https://parmanode.com/ParmanodL.torrent
set_terminal ; echo -e "
########################################################################################

    The torrent file has been downloaded to:

    $HOME/parman_programs/
    
    You can open this with the qBittorrent program.

########################################################################################
"
return 0

;;

*) invalid ;;

esac
done
}

