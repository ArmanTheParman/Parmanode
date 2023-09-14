function menu_sparrow {
while true ; do 

source $HOME/.parmanode/electrum.connection >/dev/null 2>&1

set_terminal ; echo "
########################################################################################
                                 Electrum Menu                               
########################################################################################

                      ELECTRUM CONNECTION TYPE: $connection


         (start)                 Start Electrum 

----------------------------------------------------------------------------------------

                          CONFIGURATION MODIFICATIONS

         (ssl)     Connect Electrum to Fulcrum via ssl (port 50002)

         (tcp)     Connect Electrum to Fulcrum via tcp (port 50001)

         (tcp2)    Connect Electrum to electrs via tcp (port 50005)

         (ssl2)    Connect Electrum to electrs via tcp (port 50006)

         (tor)     Connect Electrum via Tor
         
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

