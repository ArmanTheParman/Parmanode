function menu_lnd_wallet {
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
echo -e "

      (ul)             Unlock Wallet

      (wb)             Wallet balance

      (au)             Enable auto-unlock wallet (for easy restarts of LND)

      (delete)         Delete existing wallet and its files (macaroons, channel.db)

      (create)         Create an LND wallet (or restore a wallet with seed)

########################################################################################
"
choose "xpmq" ; read choice
case $choice in
m) back2main ;;
q|Q) exit ;;
p|P) return 1 ;;

au|AU|Au)
lnd_wallet_unlock_password
;;

create|CREATE|Create)
create_wallet ; lncli unlock 
return 0 ;;

ul|UL|Ul|unlock|Unlock) 
lncli unlock
return 0
;;

wb|WB)
set_terminal
lncli walletbalance
enter_continue
return 0
;;

delete|DELETE|Delete) 
delete_wallet 
return 0
;;

*) invalid
;;
esac
done

}