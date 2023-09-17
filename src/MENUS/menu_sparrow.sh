function menu_sparrow {
while true ; do 

source $HOME/.parmanode/sparrow.connection >/dev/null

set_terminal ; echo "
########################################################################################
                                 Sparrow Menu                               
########################################################################################

                      SPARROW CONNECTION TYPE: $connection


         (start)                 Start Sparrow 

----------------------------------------------------------------------------------------

                          CONFIGURATION MODIFICATIONS
                          
         (d)       Connect Sparrow directly to Bitcoin Core via tcp (default)

         (tor)     Connect Sparrow via Tor (Fulcrum)

         (ssl)     Connect Sparrow to Fulcrum via ssl (port 50002)

         (tcp)     Connect Sparrow to Fulcrum via tcp (port 50001)

         (ers)     Connect Sparrow to electrs via tcp (port 50005)

         (rtor)    Connect to a remote Electrum/Fulcrum server (eg a friend's)
         
----------------------------------------------------------------------------------------

         (t)       Troubleshooting

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
no_mac || return 1
sparrow_fulcrumtor
;;

ssl|Ssl|SSL)
no_mac || return 1
sparrow_fulcrumssl
;;

tcp|TCP|Tcp)
sparrow_fulcrumtcp
;;

rtor|Rtor|RTOR)
sparrow_remote
;;

ers|ERS|Ers)
sparrow_electrs
;;

t|T)
troubleshooting_sparrow
;;

*)
invalid
;;

esac
done
}

