function menu_electrum {
while true ; do 

source $HOME/.parmanode/electrum.connection >/dev/null 2>&1
if cat $HOME/.electrum/config | grep "\"server" | grep "7002" >/dev/null ; then connection=${green}fulcrumTOR ; fi
if cat $HOME/.electrum/config | grep "\"server" | grep "7004" >/dev/null ; then connection=${green}electrsTOR ; fi

set_terminal ; echo -e "
########################################################################################
                                   ${cyan}Electrum Menu${orange}
########################################################################################



$green            start) $orange          Start Electrum (opens in its own window)
         
$green            mm)     $orange         Manage node connection...

$green            ec) $orange             View Electrum Config file (ecv for vim)

$green            cl)     $orange         Clear connection certificates 
                          $orange         (can help connection issues)
                  
$green            w) $orange              Show saved wallet files

$green            eg) $bright_blue             Parman's Electrum Guide

$orange

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
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
enter_continue
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


             CURRENT DETECTYED ELECTRUM CONNECTION TYPE: $green$connection$orange
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
choose xpmq ; read choice ; set_terminal
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