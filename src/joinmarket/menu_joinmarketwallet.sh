function menu_joinmarket2 {
while true ; do
set_terminal ; echo -en "
########################################################################################$cyan

                                P A R M A J O I N
                                   Wallet Menu $orange

########################################################################################

    Active wallet is:    $red$wallet$orange


$cyan
                  load)$orange        Load wallet 
$cyan
                  delete)$orange      Delete JoinMarket Wallet 
$cyan
                  cp)$orange          Change wallet encryption password 
$cyan
                  ss)$orange          Show wallet seed words
$cyan
                  bk)$orange          Backup wallet file
$cyan
                  hist)$orange        Show a history of the wallet's transactions
$cyan
                  sp)$orange          Spending from the wallet (info) 
$cyan
                  cr)$orange          Create/Recover JoinMarket Wallet (with info)
$cyan
                  da)$orange          Display addresses & balances
$cyan
                  di)$orange          Display but including internal addresses
$cyan
                  sum)$orange         Summary of balances
$cyan
                  su)$orange          Show wallet UTXOs

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 
m|M) back2main ;;
q|Q|QUIT|Quit) exit 0 ;;
p|P) return 0 ;; 
esac
done
