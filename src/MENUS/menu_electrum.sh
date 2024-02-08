function menu_electrum {
while true ; do 

source $HOME/.parmanode/electrum.connection >/dev/null 2>&1
if cat $HOME/.electrum/config | grep "\"server" | grep "7002" >/dev/null ; then connection=${green}fulcrumTOR ; fi
if cat $HOME/.electrum/config | grep "\"server" | grep "7004" >/dev/null ; then connection=${green}electrsTOR ; fi

set_terminal ; echo -e "
########################################################################################
                                   ${cyan}Electrum Menu${orange}
########################################################################################
$cyan
                        ELECTRUM CONNECTION TYPE: $green$connection$orange


            start)    Start Electrum (opens in its own window)
         
            rf)       Refresh connection files (to troublshoot server connection)

----------------------------------------------------------------------------------------
$cyan
                           CONFIGURATION MODIFICATIONS
$orange

            fs)       Connect to Fulcrum via SSL (port 50002)

            ft)       Connect to Fulcrum via TCP (port 50001)

            et)       Connect to electrs via TCP (port 50005)

            es)       Connect to electrs via SSL (port 50006)

            ftor)     Connect to Fulcrum via Tor 

            etor)     Connect to electrs via Tor 

            ec)       View Electrum Config file
    $bright_blue
            eg)       Parman's Electrum Guide
    $orange
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
return 0 ;;

fs|FS)
check_fulcrum_ssl
modify_electrum_config fulcrumssl
;;
ft|FT|Ft|Ft)
check_fulcrum_tcp
modify_electrum_config fulcrumtcp
;;
es|ES|Es)
check_electrs_ssl
modify_electrum_config electrsssl
;;
et|ET|Et)
check_electrs_tcp
modify_electrum_config electrstcp 
;;
ftor|FTOR|Ftor)
enable_electrum_tor "fulcrum" 
;;
etor|ETOR|Etor)
enable_electrum_tor "electrs"
;;
ec|EC) 
nano $HOME/.electrum/config
;;

rf|RF)
clear_dot_electrum
;;

eg|EG)
parmans_electrum_guide
;;

*)
invalid
;;
esac
done
}

