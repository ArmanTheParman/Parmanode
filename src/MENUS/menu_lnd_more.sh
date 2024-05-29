function menu_lnd_more {
source $pc
menuDockerIP="$bright_blue                 IP address of LND (Docker Contaier) = $LNDIP$orange"

while true ; do set_terminal ; echo -en "
########################################################################################$cyan
                                LND Menu${orange} - v$lnd_version                               
########################################################################################

$menuDockerIP

      (ex)             Expose your LND node to other nodes

      (reset)          Reset lnd.conf to default

      (alias)          Change LND alias

      (port)           Change CLEARNET port. Current port is $lnd_port 

      (mm)             Macaroon information (private and sensitive)
      
      (up)             Info on updating (easy peasy lemon squeezy)

########################################################################################
"

choose "xpmq" ; read choice
case $choice in
m|M) back2main ;;
q|Q) exit ;;
p|P) 
clear
please_wait ; return 1 ;;

ex|Ex|EX)
expose_LND
;;

alias|ALIAS|Alias) 
set_lnd_alias ;;

port|Port)
change_lnd_port
;;

up|UP)
update_lnd
;;

reset|RESET|Reset)
reset_lnd_conf
;;

mm|MM|Mm)
lnd_macaroons
;;

*)
invalid ;;
esac
done
} 

function reset_lnd_conf {

if grep -q "litd" < $ic ; then
announce "Not available for LITD installation, only LND installations"
return 0
fi

local file="$HOME/.lnd/lnd.conf"
set_terminal
rm $file
make_lnd_conf
if [[ $OS == Mac ]] ; then
gsed -i '/^; wallet-unlock-password-file/s/^..//' $HOME/.lnd/lnd.conf
gsed -i '/^; wallet-unlock-allow-create/s/^..//' $HOME/.lnd/lnd.conf
else
sed -i '/^; wallet-unlock-password-file/s/^..//' $HOME/.lnd/lnd.conf
sed -i '/^; wallet-unlock-allow-create/s/^..//' $HOME/.lnd/lnd.conf
fi

restart_lnd
}
