function menu_joinmarketwallet {
if ! grep -q "joinmarket-end" $ic ; then return 0 ; fi
while true ; do
set_terminal 48 88 ; echo -en "
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


${red}These options will work from the main joinmarket menu $orange
########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
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
    jmvenv "activate"
    $hp/joinmarket/scripts/wallet-tool.py $wallet summary | tee $tmp/jmaddresses
    jmvenv "deactivate"
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
    yesorno "Be careful with who sees your screen, the seed words will be printed!
    Do you really want to continue?" || continue
    jmvenv "activate"
    $hp/joinmarket/scripts/wallet-tool.py $wallet showutxos 
    jmvenv "deactivate"
    enter_continue
    ;;
h|hist)
    wallet_history_jm
    ;;
cp)
    check_wallet_loaded || continue
    jmvenv "activate"
    $hp/joinmarket/scripts/wallet-tool.py $wallet changepass 
    jmvenv "deactivate"
    ;;
bk)
    backup_jm_wallet
    ;;

delete)
    delete_jm_wallets
    ;; 
ss)
    check_wallet_loaded || continue
    jmvenv "activate"
    $hp/joinmarket/scripts/wallet-tool.py $wallet showseed
    jmvenv "deactivate"
    enter_continue
    ;;
"")
continue ;;
*)
invalid
;;
esac
done
}