function spending_info_jm {

set_terminal ; echo -e "
########################################################################################

    Parmanode does not recommend or enable terminal based commands to spend from the
    JM wallets. It's best that you restore your seed into a hardware wallet device,
    and explore your wallets using Sparrow or Electrum. Then generate transactions
    from there.

    Remember that you'll need to modify the 'account' value in the derivation path
    to see all your mixing depths.

    If you really want to use the command prompt to spend coins out of this wallet,
    eg if you lost your seed an you only have a JM wallet file, then you can choose 
    the manual access from the menu. You'll then be in the Docker container at the 
    directory with all the scripts. You can look up the JoinMarket documentation 
    and execute whichever script you want.

    I may include functions to do this automatically one day, and can take requests
    if there is demand.

########################################################################################
"
enter_continue
return 0
}
