function menu_tools2 {

while true ; do
set_terminal_high
echo -e "
########################################################################################
  $cyan
                               P A R M A N O D E - Tools   $orange


              (curl)      Test bitcoin curl/rpc command (for troubleshooting)

              (grpcurl)   RPC call test to LND

              (rf)        Refresh Parmanode script directory              

              (sr)        System report (for getting troubleshooting help)

              (ww)        Wireless driver install (rtl8812au)

              (fs)        Free up some space

$orange
########################################################################################
"
choose "xpmq" ; read choice ; set_terminal

case $choice in
    
q|Q) exit ;;  m|M) back2main ;; p|P) return 0 ;;

curl)
bitcoin_curl
return 0
;;

grpcurl)
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

ww)
wireless_driver_install
;;

fs)
free_up_space
;;

*)
invalid 
;;
esac
done
return 0
}