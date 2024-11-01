function jm_create_wallet_tool {
while true ; do
set_terminal_custom 47 ; echo -e "
########################################################################################

    Wallet files will be kept inside the container at$cyan /root/.joinmarket/wallet $orange

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
    It will then ask:
$red
    Would you like this wallet to support fidelity bonds? Write 'n' if you don't 
    know what this is (y/n): 
$orange
    I personally have not investigated this feature enough to advise, so I'll be
    choosing 'n'. You do what you think is best. Type$cyan f$orange and $green<enter>$orange if 
    you want more info on Fidelity Bonds (sourced from ChatGPT). TL;DR - It's a 
    privacy feature.

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

function delete_jm_wallets {

set_terminal ; echo -e "
########################################################################################

    The following is a list of the contents of$cyan $HOME/.joinmarket/wallets/:
$pink
$(ls $HOME/.joinmarket/wallets/)
$orange

    Are you sure you want to delete everything in there?
$red
                 yolodelete)   delete it all
$green
                 *)            Any other key will abort
$orange
########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
yolodelete)
sudo rm -rf $HOME/.joinmarket/wallets/*
enter_continue "DONE"
;;
*)
return 1
;;
esac
}


function display_jm_addresses {

set_terminal ; echo -e "
########################################################################################

    The wallet addresses will be printed for you inside the 'less' command. Use the
    keyboard arrows to go up and down (you can actually use vim commands if you know
    them). Then hit 'q' to exit it.

########################################################################################
"
enter_continue

    case $1 in
    a)
    docker exec -it joinmarket bash -c "/jm/clientserver/scripts/wallet-tool.py $wallet displayall" | tee /tmp/jmaddresses
    ;;
    *)
    docker exec -it joinmarket bash -c "/jm/clientserver/scripts/wallet-tool.py $wallet display" | tee /tmp/jmaddresses
    ;;
    esac

    if grep -q "just restart this joinmarket application" < /tmp/jmaddresses ; then

        enter_continue "$pink
        This always happens the first time you access the display function.
        Please hit enter to run the display command again.
        $orange"
        case $1 in
        a)
        docker exec -it joinmarket bash -c "/jm/clientserver/scripts/wallet-tool.py wallet.jmdat displayall" | tee /tmp/jmaddresses
        ;;
        *)
        docker exec -it joinmarket bash -c "/jm/clientserver/scripts/wallet-tool.py wallet.jmdat display" | tee /tmp/jmaddresses
        ;;
        esac

    fi

clear
sed -i '1,/[Mm]ixdepth/{/[Mm]ixdepth/!d}' /tmp/jmaddresses
sed -i -r 's/\x1B\[[0-9;]*[a-zA-Z]//g' /tmp/jmaddresses #removeds escape characters
sed -i '/^[Mm]ixdepth/i\\' /tmp/jmaddresses
sed -i "1i##################################### wallet.jmdat #####################################" /tmp/jmaddresses
echo "
####################################### END #########################################" | tee -a /tmp/jmaddresses >$dn
set_terminal_wide
less /tmp/jmaddresses
#rm /tmp/jmaddresses >$dn 2>&1
enter_continue

}

function check_wallet_loaded {
    if [[ $wallet == NONE ]] ; then
    announce "Please load wallet first"
    return 1
    fi
    return 0
}

function fidelity_bonds_info {
set_terminal ; echo -e "
########################################################################################
$cyan
    Fidelity bonds$orange in JoinMarket are a privacy-enhancing feature that works by 
    proving ownership of coins that are time-locked. By locking up coins for a set 
    period, participants can provide a stronger signal of long-term commitment to the 
    network, which makes it more difficult for observers to link transactions and 
    reduces the risk of Sybil attacks in coinjoins.

    When you choose 'yes' for fidelity bonds during wallet creation, JoinMarket 
    enables the wallet to support this feature. This means that, if you wish to 
    participate in coinjoins as a maker, you can lock up some of your coins for a 
    fixed period. The longer you lock your coins, the more weight or "fidelity" your 
    bonds have, making you a more attractive coinjoin partner. Fidelity bonds 
    improve the privacy of both makers and takers in the JoinMarket system.

    If you're planning to use JoinMarket frequently as a maker, enabling 
    fidelity bonds can increase your chances of being selected for coinjoin rounds. 
    However, it requires locking up coins, so it's a feature meant for more 
    advanced users who are okay with having some funds time-locked for privacy 
    benefits.

########################################################################################
"
enter_continue
return 0
}