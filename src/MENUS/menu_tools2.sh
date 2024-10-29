function menu_tools2 {

while true ; do
set_terminal_high
echo -en "
########################################################################################$cyan
                                   TOOLS - PAGE 2  $orange
########################################################################################


$cyan              (bd)$orange        Install Bitcoin to a running Docker container

$cyan              (as)$orange        AutoSSH reverse proxy tunnel guide

$cyan              (curl)$orange      Test bitcoin curl/rpc command (for troubleshooting)

$cyan              (de)$orange        Drive encryption - info

$cyan              (fs)$orange        Free up some space

$cyan              (gc)$orange        RPC call test to LND (grpcurl)

$cyan              (rest)$orange      REST protocol test to LND (info only)

$cyan              (rf)$orange        Refresh Parmanode script directory              

$cyan              (sr)$orange        System report (for getting troubleshooting help)

$orange
########################################################################################
"
choose "xpmq" ; read choice ; set_terminal

case $choice in
    
q|Q) exit ;;  m|M) back2main ;; p|P) return 0 ;;

bd)
install_bitcoin_docker
return 0
;;

curl)
bitcoin_curl
return 0
;;

gc)
grpccurl_call
;;

rf)
parmanode_refresh
return 0
;;

sr)
system_report
return 0
;;

fs)
free_up_space
;;

rest)
rest_protocol_test
;;

as)
autossh_setup
;;

de)
drive_encryption
;;

*)
invalid 
;;
esac
done
return 0
}