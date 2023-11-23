function menu_sparrow {
while true ; do 
unset sversion
if [[ $OS == Mac ]] ; then
sversion=$(/Applications/Sparrow.app/Contents/MacOS/Sparrow --version | grep -Eo '[0-9].+$')
else
sversion=$($hp/Sparrow/bin/Sparrow --version | grep -Eo '[0-9].+$')
fi

source $HOME/.parmanode/sparrow.connection >/dev/null

set_terminal ; echo -e "
########################################################################################
                  $cyan         Sparrow Menu -- Version $sversion                  $orange      
########################################################################################

                      SPARROW CONNECTION TYPE: $connection


         (start)                 Start Sparrow 

----------------------------------------------------------------------------------------

                          CONNECTION OPTIONS 
                          
         (d)       To Bitcoin Core via tcp (default)

         (ssl)     To Fulcrum via ssl (port 50002)

         (tcp)     To Fulcrum via tcp (port 50001)

         (tor1)    To Fulcrum via Tor (port 7002)

         (ers)     To electrs via tcp (port 50005)
        
          N/A      To electrs via SSL (Not available)

         (tor2)    To electrs via Tor (port 7004) 

         (rtor)    To a remote Electrum/Fulcrum server via Tor (eg a friend's)
         
----------------------------------------------------------------------------------------

         (t)       Troubleshooting

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 
m|M) back2main ;;
q|Q|QUIT|Quit) exit 0 ;;
p|P) menu_use ;; 
start|Start|START|S|s)
check_SSH || return 0
check_wallet_connected "Sparrow"
run_sparrow
return 0 ;;

d|D)
sparrow_core
;;

tor1|Tor1|TOR1)
no_mac || return 1
sparrow_fulcrumtor
;;

tor2|Tor2|TOR2)
no_mac || return 1
sparrow_electrstor
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

