function menu_sparrow {
while true ; do set_terminal ; echo "
########################################################################################
                                 Sparrow Menu                               
########################################################################################


         (start)                 Start Sparrow 


----------------------------------------------------------------------------------------

                          CONFIGURATION MODIFICATIONS
                          
         (d)       Connect Sparrow directly to Bitcoin Core via tcp (default)

         (tor)     Connect Sparrow via Tor

         (ssl)     Connect Sparrow to Fulcrum vis ssl

         (rtor)    Connect to a remote Electrum/Fulcrum server (eg a friend's)
                    - available for Mac
         
         (torssl)  Connect by Tor with SSL (NOT AVAILABLE)


########################################################################################
"
choose "xpq" ; read choice ; set_terminal
case $choice in 
q|Q|QUIT|Quit) exit 0 ;;
p|P) return 1 ;;

start|Start|START|S|s)
run_sparrow
return 0 ;;

d|D)
sparrow_core
;;

tor|Tor|TOR)
no_mac
sparrow_fulcrumtor
;;

ssl|Ssl|SSL)
no_mac
sparrow_fulcrumssl
;;

rtor|Rtor|RTOR)
sparrow_remote
;;

*)
invalid
;;

esac
done
}
