function menu_phoenix {
while true ; do 
if ! grep -q "phoenix-end" $ic ; then return 0 ; fi

set_terminal ; echo -e "
########################################################################################$cyan
                              Phoenix Server Menu $orange
########################################################################################


$cyan            start) $orange          Start Phoenix Server Daemon

$cyan            stop)  $orange          Start Phoenix Server Daemon

########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
m|M) back2main ;; q|Q|QUIT|Quit) exit ;; p|P) menu_use ;; 

start|Start|START|S|s)
check_SSH || return 0
run_electrum
return 0 ;;

mm|MM)
electrum_connection_menu
;;

ec|EC) 
nano $HOME/.electrum/config
;;
ecv|ECV) 
vim_warning ; vim $HOME/.electrum/config
;;

cl|CL)
clear_dot_electrum
;;

eg|EG)
parmans_electrum_guide
;;

w|W)
set_terminal_high
echo -e "
########################################################################################


    Directory:$cyan $HOME/.electrum/wallets/ $orange


    Files: $bright_blue

$(ls $HOME/.electrum/wallets)

$orange
########################################################################################
"
enter_continue ; jump $enter_cont
set_terminal
;;

*)
invalid
;;
esac
done
}


function electrum_connection_menu {

while true ; do
set_terminal
echo -e "
########################################################################################
$cyan
                            ELECTRUM CONNECTION OPTIONS $orange

########################################################################################


             CURRENT DETECTED ELECTRUM CONNECTION TYPE: $green$connection$orange
$orange

$green            fs) $orange      Connect to Fulcrum via SSL (port 50002)

$green            ft)$orange       Connect to Fulcrum via TCP (port 50001)

$green            et)     $orange  Connect to electrs via TCP (port 50005)

$green            es)$orange       Connect to electrs via SSL (port 50006)

$green            ftor)    $orange Connect to Fulcrum via Tor 

$green            etor)$orange     Connect to electrs via Tor 

    $orange
########################################################################################
"
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 0 ;; m|M) back2main ;;

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
*)
invalid
;;
esac
done
}
