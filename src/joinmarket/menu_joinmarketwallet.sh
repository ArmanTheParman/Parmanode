function menu_joinmarketwallet {
if ! grep -q "joinmarket-end" $ic ; then return 0 ; fi
while true ; do
set_terminal ; echo -en "
########################################################################################$cyan

                                P A R M A J O I N
                                   Wallet Menu $orange

########################################################################################

    Active wallet is:    $magenta$wallet$orange


$cyan
                  cr)$orange          Create or Recover JoinMarket Wallet (with info)
$cyan
                  load)$orange        Load wallet (or change to another wallet)
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
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
m|M) back2main ;; q|Q|QUIT|Quit) exit 0 ;; p|P) return 0 ;; 

cr)
    jmvenv "activate"
    jm_create_wallet_tool
    jmvenv "deactivate"
;;
l|load)
    set_terminal
    jmvenv "activate"
    choose_wallet || continue
    jmvenv "deactivate"
;;
sum)
    check_wallet_loaded || continue
    jmvenv "activate"
    $hp/joinmarket/scripts/wallet-tool.py $wallet summary | tee $tmp/jmaddresses
    jmvenv "deactivate"
    enter_continue
    ;;
da)
    check_wallet_loaded || continue
    jmvenv "activate"
    display_jm_addresses
    jmvenv "deactivate"
    ;; 
di)
    check_wallet_loaded || continue
    jmvenv "activate"
    display_jm_addresses a
    jmvenv "deactivate"
    ;;
su)
    check_wallet_loaded || continue
    jmvenv "activate"
    $hp/joinmarket/scripts/wallet-tool.py $wallet showutxos 
    jmvenv "deactivate"
    enter_continue
    ;;
h|hist)
    jmvenv "activate"
    wallet_history_jm
    jmvenv "deactivate"
    ;;
cp)
    check_wallet_loaded || continue
    jmvenv "activate"
    $hp/joinmarket/scripts/wallet-tool.py $wallet changepass 
    jmvenv "deactivate"
    ;;
bk)
    jmvenv "activate"
    backup_jm_wallet
    jmvenv "deactivate"
    ;;

delete)
    jmvenv "activate"
    delete_jm_wallets
    jmvenv "deactivate"
    ;; 
ss)
    check_wallet_loaded || continue
    jmvenv "activate"
    $hp/joinmarket/scripts/wallet-tool.py $wallet showseed
    jmvenv "deactivate"
    enter_continue
    ;;
*)
invalid
;;
esac
done
}