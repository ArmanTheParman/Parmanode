function delete_wallet_lnd {
while true ; do
set_terminal "pink" ; echo -e "
########################################################################################
$cyan
                                Delete LND Wallet?
$orange
    Be careful, and be sure you want to do this. Make sure you have your seed phrase
    backed up (and tested). By that, I mean that if you have significant funds in
    the wallet, you should make sure that the wallet can be recovered on a different
    computer. If the backup test fails, then your seed backup is not good, and the 
    wallet you're about to delete is your only copy. When you test it, do so offline,
    check the addresses generated are correct, and then—only then—delete it. It 
    should be done offline so that there are not conflicts with the existing LND node.

    If you type$green (delete)$orange then <enter> ...
    
                       - the wallet file will be deleted
                       - the channel.db file will be deleted 
                       - the channel.backup file (not any that you saved to desktop)
                       - the macaroons for the wallet will be deleted

                 (\"macarooni whaty what?\" - Don't worry about it)

########################################################################################
"
choose "xpmq" ; read choice
case $choice in
m|M) back2main ;;
Q|q|Quit|QUIT|quit) 
exit 0 ;;
p|P) return 1 ;;
delete|DELETE|Delete) 
break ;;
*) invalid ;;
esac
done

stop_lnd
rm $HOME/.lnd/data/chain/bitcoin/mainnet/*
start_lnd
enter_continue
return 0
}
