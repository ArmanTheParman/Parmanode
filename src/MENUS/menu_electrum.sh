function menu_electrum {
while true ; do 

source $HOME/.parmanode/electrum.connection >/dev/null 2>&1
if cat $HOME/.electrum/config | grep "\"server" | grep "7002" >/dev/null ; then connection=fulcrumTOR ; fi
if cat $HOME/.electrum/config | grep "\"server" | grep "7004" >/dev/null ; then connection=electrsTOR ; fi

set_terminal ; echo -e "
########################################################################################
                                   ${cyan}Electrum Menu${orange}
########################################################################################
$cyan
                        ELECTRUM CONNECTION TYPE: $connection
$orange

         start)  Start Electrum
         
         rf)     Refresh connection files (to troublshoot server connection)

----------------------------------------------------------------------------------------
$cyan
                          CONFIGURATION MODIFICATIONS
$orange

         ssl)   Connect to Fulcrum via ssl (port 50002)

         tcp)   Connect to Fulcrum via tcp (port 50001)

         tcp2)  Connect to electrs via tcp (port 50005)

         ssl2)  Connect to electrs via ssl (port 50006)

         tor1)  Connect to Fulcrum via Tor 

         tor2)  Connect to electrs via Tor 

         ec)    View Electrum Config file

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 
m|M) back2main ;;
q|Q|QUIT|Quit) exit 0 ;;
p|P) menu_use ;; 
start|Start|START|S|s)
check_SSH || return 0
check_wallet_connected "Electrum"
run_electrum
enter_continue
return 0 ;;

ssl|Ssl|SSL)
check_fulcrum_ssl
modify_electrum_config fulcrumssl
;;
tcp|TCP)
check_fulcrum_tcp
modify_electrum_config fulcrumtcp
;;
ssl2|Ssl2|SSL2)
check_electrs_ssl
modify_electrum_config electrsssl
;;
tcp2|TCP2)
check_electrs_tcp
modify_electrum_config electrstcp 
;;
tor1|TOR1)
enable_electrum_tor "fulcrum" 
;;
tor2|TOR2)
enable_electrum_tor "electrs"
;;
ec|EC) 
nano $HOME/.electrum/config
;;

rf|RF)
clear_dot_electrum
;;

*)
invalid
;;
esac
done
}

