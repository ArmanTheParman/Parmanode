function menu_lnd_more {

export lnd_version=$(lncli --version | cut -d - -f 1 | cut -d ' ' -f 3) >/dev/null

while true ; do set_terminal ; echo -e "
########################################################################################$cyan
                                LND Menu${orange} - v$lnd_version                               
########################################################################################

"
if ps -x | grep lnd | grep bin >/dev/null 2>&1 ; then echo "
                   LND IS RUNNING -- SEE LOG MENU FOR PROGRESS "
else
echo "
                   LND IS NOT RUNNING -- CHOOSE \"start\" TO RUN"
fi
echo "

      (ex)             Expose your LND node to other nodes

      (alias)          Change LND alias

      (port)           Change CLEARNET port. Current port is $lnd_port 
"
if [[ $lnd_version != "v0.17.0" ]] ; then echo -e " 
$red      (update)         Update LND to version 0.17.0 $orange
      "
fi
echo "########################################################################################
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

update|UPDATE|Update)
update_lnd
;;

*)
invalid ;;
esac
done
} 