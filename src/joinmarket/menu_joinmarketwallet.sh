function menu_joinmarket2 {
while true ; do
set_terminal ; echo -en "
########################################################################################$cyan

                                P A R M A J O I N
                                   Wallet Menu $orange

########################################################################################

    Active wallet is:    $red$wallet$orange


$cyan
                  cr)$orange          Create or Recover JoinMarket Wallet (with info)
$cyan
                  load)$orange        Load wallet 
$cyan
                  sum)$orange         Summary of balances
$cyan
                  da)$orange          Display - addresses & balances
$cyan
                  di)$orange          Display - including internal addresses
$cyan
                  su)$orange          Show wallet UTXOs
$cyan
                  hist)$orange        Show a history of the wallet's transactions
$cyan
                  cp)$orange          Change wallet encryption password 
$cyan
                  bk)$orange          Backup wallet file
$cyan
                  delete)$orange      Delete JoinMarket Wallet 
$cyan
                  ss)$orange          Show wallet seed words

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 
m|M) back2main ;; q|Q|QUIT|Quit) exit 0 ;; p|P) return 0 ;; 

cr)
    jm_create_wallet_tool
;;
l|load)
    set_terminal
    choose_wallet || continue
;;
sum)
    check_wallet_loaded || continue
    docker exec -it joinmarket bash -c "/jm/clientserver/scripts/wallet-tool.py $wallet summary" | tee $tmp/jmaddresses
    enter_continue
    ;;
da)
    check_wallet_loaded || continue
    display_jm_addresses
    ;; 
di)
    check_wallet_loaded || continue
    display_jm_addresses a
    ;;
su)
    check_wallet_loaded || continue
    docker exec -it joinmarket bash -c "/jm/clientserver/scripts/wallet-tool.py $wallet showutxos" 
    enter_continue
    ;;
h|hist)
    wallet_history_jm
    ;;
cp)
    check_wallet_loaded || continue
    docker exec -it joinmarket bash -c "/jm/clientserver/scripts/wallet-tool.py $wallet changepass" 
    ;;
bk)
    backup_jm_wallet
    ;;

delete)
    delete_jm_wallets
    ;; 
ss)
    check_wallet_loaded || continue
    docker exec -it joinmarket bash -c "/jm/clientserver/scripts/wallet-tool.py $wallet showseed" 
    enter_continue
    ;;
*)
invalid
;;
esac
done
}