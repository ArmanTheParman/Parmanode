function jm_creat_wallet_tool {
while true ; do
set_terminal_custom 47 ; echo -e "
########################################################################################

    Wallet files will be kept inside the container at$cyan /root/.joinmarket/wallet 

    You will first be asked:
$red
    Would you like to use a two-factor mnemonic recovery phrase? Write 'n' if you 
    don't know what this is (y/n): 
$orange
    The wording is confusing. It's referring to a 'PASSPHRASE', or 13th custom word.

    It will then ask:
$red
    Enter new passphrase to encrypt wallet: 
$orange
    Truly horrible terminology! It is using 'passphrase' instead of 'PASSWORD', 
    which is some text to encrpyt (lock) the file, and is not part of the wallet
    entropy. This can't be left blank.

    It will then ask:
$red
    Input wallet file name (default: wallet.jmdat): 
$orange
    lease do not change the filename or Parmanode menus will get confused. 
    Let's keep it simple.
    
    It will then ask:
$red
    Would you like this wallet to support fidelity bonds? Write 'n' if you don't 
    know what this is (y/n): 
$orange
    I personally have not investigated this feature enough to advise, so I'll be
    choosing 'n'. You do what you think is best.

    Type$cyan f$orange and $green<enter>$orange if you want more info on Fidelity Bonds (sourced from ChatGPT)

########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
f) fidelity_bonds_info ;;
*)
break ;;
esac
done
return 0
}
