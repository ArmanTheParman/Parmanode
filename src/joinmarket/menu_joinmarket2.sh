function menu_joinmarket2 {
while true ; do
set_terminal ; echo -en "
########################################################################################$cyan

                                P A R M A J O I N
                                      Menu 2$orange

########################################################################################

    Active wallet is:    $red$wallet$orange


$cyan
                  vc)$orange          Remove all config comments and make pretty
$cyan
                  man)$orange         Manually access container and mess around
$cyan
                  sp)$orange          Spending (info) 

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 
m|M) back2main ;;
q|Q|QUIT|Quit) exit 0 ;;
p|P) return 0 ;; 

vc)
cfg="$HOME/.joinmarket/joinmarket.cfg" 
sed '/^#/d' $cfg | sed '/^$/d' | sed '/\[/a\ ' | sed '/\[/i\ ' | tee $tmp/cfg >$dn 2>&1
sudo mv $tmp/cfg $cfg
enter_continue "file modified"
;;
man)
clear
enter_continue "Type exit and <enter> to return from container back to Parmanode"
clear
docker exec -it joinmarket bash 
;;

sp)
spending_info_jm
;;
    
*)
invalid
;;
esac
done
}
