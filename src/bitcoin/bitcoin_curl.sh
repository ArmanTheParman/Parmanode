function bitcoin_curl {
source $bc

while true ; do
set_terminal ; echo -en "
########################################################################################

    The curl command to the bitcoin daemon, to run in terminal is...
$cyan

curl --user $rpcuser:$rpcpassword --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getblockchaininfo", "params": [] }' -H 'content-type: text/plain;' http://$IP:8332
$orange
    Parmanode can run this command for you or you can copy/paste it yourself, and
    make edits as needed.
$green
               d)      Do it for me
$orange
            <enter>    I'll do it, moving on.

########################################################################################
"
choose "xpmq" ; read choice
set_terminal
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