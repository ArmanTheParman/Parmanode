function menu_vaultwarden {
while true ; do 
if ! grep -q "tailscale-end" $ic ; then pca="${red}Not Installed" ; fi
get_onion_address_variable vaultwarden
set_terminal 40 110 ; echo -e "
##############################################################################################################$cyan
                                             VaultWarden Menu            $orange                   
##############################################################################################################

    VaultWarden is: $vwr                                                                     

    Connection TCP:$cyan  http://localhost:19080 ; http://$IP:19080 ; http://127.0.0.1:19080$orange
    Connection SSL: $cyan https://localhost:19443 ; https://$IP:19443 ; https://127.0.0.1:19443$orange
    Connection Tor:$cyan  http://$ONION_ADDR_VAULTWARDEN:7009 $orange
    Connection ParmaScale:$cyan $pca$orange

$green
                      start)$orange         Start VaultWarden Docker container
$red
                       stop)$orange         Stop VaultWarden Docker container
$cyan
                    restart)$orange         Resart VaultWarden Docker container

$orange
##############################################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
m|M) back2main ;; q|Q|QUIT|Quit) exit 0 ;; p|P) menu_use ;; 
start|Start|START|S|s)
start_vaultwarden
;;
stop)
stop_vaultwarden
;;
restart)
restart_vaultwarden
;;
"")
continue ;;
*)
invalid
;;
esac
done
} 