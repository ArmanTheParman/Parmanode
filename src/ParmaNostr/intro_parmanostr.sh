function intro_parmanostr {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                              P A R M A N O S T R 
$orange
########################################################################################

$orange      
    ParmaNostr is just getting started - I have big dreams for it. 
    For now, it's just a tool to build (or import) your own Nostr key pair. You can - 
    

$green            a)$orange Enter your own mnemonic seed phrase from a 12 word BIP-39 

$green            b)$orange Enter 128 bits (from dice or coins as per my seed guide)

$green            c)$orange Input your own keys

$green            d)$orange Bring in a hex private key from the ColdCard (eg BIP-85)


    ParmaNostr will store the info on the computer at:

    ${bright_blue}$dp/.nostr_keys/$orange

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