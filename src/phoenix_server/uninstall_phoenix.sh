function uninstall_phoenix {

while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                            Uninstall Phoenix Server
$orange
    Are you sure? 

                    y)    Yes, uninstall

                    n)    Nah, abort


########################################################################################
"
choose xpmq ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
n) return 1 ;; y) break ;;
esac
done

set_terminal
stop_phoenix 2>$dn
rm -rf $hp/phoenix

installed_conf_remove "phoenix"
success "Phoenix Server has been uninstalled"

}