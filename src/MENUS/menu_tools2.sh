function menu_tools {

while true ; do
set_terminal_high
echo -e "
########################################################################################
  $cyan
                               P A R M A N O D E - Tools   $orange


              (curl)      Test bitcoin curl/rpc command (for troubleshooting)
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

*)
invalid 
;;
esac
done
return 0
}

function bitcoin_curl {
source $bc

while true ; do
set_terminal ; echo -en "
########################################################################################

    The curl command to the bitcoin daemon, to run in terminal is...
$cyan

curl --user $rpcuser:$rpcpassword --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getblockchaininfo", "params": [] }' -H 'content-type: text/plain;' http://$IP:8332

    Parmanode can run this command for you or you can copy/paste it yourself, and
    make edits as needed.
$green
               d)      Do it for me
$orange
            <enter>    I'll do it, moving on.

########################################################################################
"
choose "xpmq" ; read choice
set_teminal
case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; M|m) back2main ;;
"") break ;;
d)
curl --user $rpcuser:$rpcpassword --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getblockchaininfo", "params": [] }' -H 'content-type: text/plain;' http://$IP:8332
enter_continue
break
;;
*)
invalid
;;
esac
done
}