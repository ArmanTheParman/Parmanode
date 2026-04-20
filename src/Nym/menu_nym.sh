function menu_nym {

while true ; do
set_terminal
echo "$orange
########################################################################################$cyan
                                  NYM VPN MENU$orange



$cyan
            start)$orange               Start
$cyan
             stop)$orange               Stop


########################################################################################"
choose xpmq ;  read choice 
jump $choice || { invliad ; continue ; }
case $choice in
q|Q|QUIT|Quit) exit 0 ;;
p|P) menu_use ;; 
m|M) back2main ;;
start) start_nym ;;
stop) stop_nym ;;
esac
done
}