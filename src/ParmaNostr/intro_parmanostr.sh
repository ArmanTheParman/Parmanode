function intro_parmanostr {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                              P A R M A N O S T R 
$orange      
    ParmaNostr is just getting started - I have big dreams for it. For now, it's just
    a tool to build your own Nostr key pair from a 12 word BIP-39 mnemonic, stored 
    in cleartext at$cyan $dp/.nostr_keys/

$orange
########################################################################################
"
choose epmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;

*)
break
;;
esac
done

}