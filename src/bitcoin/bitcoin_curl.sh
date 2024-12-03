function bitcoin_curl {
source $bc

while true ; do
set_terminal ; echo -en "
########################################################################################

    O comando curl para o daemon bitcoin, a ser executado no terminal é...
$cyan

curl --user $rpcuser:$rpcpassword --data-binary '{\"jsonrpc\": \"1.0\", \"id\":\"curltest\", \"method\": \"getblockchaininfo\", \"params\": [] }' -H 'content-type: text/plain;' http://$IP:8332
$orange
    O Parmanode pode executar este comando por si ou pode copiar/colar você mesmo 
    e fazer as edições necessárias.
$green
               d)      Faça-o por mim
$orange
            <enter>    Eu faço-o, vou continuar.

########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
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
