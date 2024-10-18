function uninstall_joinmarket {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                               Uninstall JoinMarket 
$orange
    Are you sure? 

                            y)    Yes, uninstall

                            n)    Nah, abort

$red
    If you want to delete the joinmarket Bitcoin Core/Knots wallet, then you
    can manually do that from the bitcoin data directory.
$orange
########################################################################################
"
choose xpmq 
read choice
set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
n)
return 1
;;
y)
break
;;
esac
done

set_terminal

stop_joinmarket

sudo rm -rf /home/joinmarket >$dn 2>&1

sudo deluser --remove-home joinmarket >$dn 2>&1
sudo delgroup joinmarket >$dn 2>&1

installed_conf_remove "joinmarket"
success "JoinMarket has been uninstalled."
}