function jm_create_wallet_tool {

announce "When making any wallet, even a hot wallet such as this, it's important to
          \r    to make sure you test the recovery of the wallet from backup - That way
          \r    you know your backup is good. 
          \r
          \r    Back ups can be the seed words, and you can restore them here, or
          \r    if you have saved the encrypted wallet file, you can just copy the
          \r    file to the directory: $HOME/.joinmarket/wallets/ 
          \r    to use the wallet with ParmaJoin.

          \r    It's possible to load your ParmaJoin wallet seed words into a hardware 
          \r    wallet but be careful not to mess around by moving coins about, it can 
          \r    disturb the coinjoining you do later - It's fine to do whatever you 
          \r    want if you plan not to mix the coins any more.

         \r     To keep things clean and simple, you could bring coins to this wallet
         \r     to coinjoin them, and once you are done, empty the coins to their
         \r     final cold storage home, and discard the coinjoin wallet."

yesorno "Do you want to create a new wallet or restore?" "cr" "create" "res" "restore" || {
    restore_jm_wallet || return 1
    return 0
    }

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
    choosing 'n'. You do what you think is best. Type$cyan f$orange and $green<enter>$orange 
    now if you want more info on Fidelity Bonds (sourced from ChatGPT). TL;DR - It's a 
    privacy feature.

########################################################################################
"
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
f) fidelity_bonds_info ;;
*)
break ;;
esac
done

> $dp/before ; > $dp/after #clear contents
#copy list of wallets to before file
for i in $(ls $HOME/.joinmarket/wallets/) ; do echo "$i" >> $dp/before 2>/dev/null ; done
docker exec -it joinmarket bash -c "/jm/clientserver/scripts/wallet-tool.py generate" 
#copy list of wallets to after file
for i in $(ls $HOME/.joinmarket/wallets/) ; do echo "$i" >> $dp/after 2>/dev/null ; done
#automatically export the new wallet
export wallet=$(diff $dp/before $dp/after | grep ">" | awk '{print $2}')
#show wallet summary
docker exec -it joinmarket bash -c "/jm/clientserver/scripts/wallet-tool.py $wallet summary" 
enter_continue
#clear before and after files
> $dp/before ; > $dp/after

return 0
}

function delete_jm_wallets {

set_terminal ; echo -e "
########################################################################################

    The following is a list of the contents of$cyan $HOME/.joinmarket/wallets/:
    
$red
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
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
yolodelete)
sudo rm -rf $HOME/.joinmarket/wallets/*
enter_continue "DONE"
unset wallet
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
$cyan
    If you also want a copy of the printout on your desktop as 'jmaddresses.txt' then
    type copy and hit <enter>. $orange

########################################################################################
"
enter_continue ; jump $enter_cont

if [[ $enter_cont == copy ]] ; then
export copyjmdesktop="true"
else
unset copyjmdesktop
fi
    case $1 in
    a)
    docker exec -it joinmarket bash -c "/jm/clientserver/scripts/wallet-tool.py $wallet displayall" | tee $tmp/jmaddresses
    ;;
    *)
    docker exec -it joinmarket bash -c "/jm/clientserver/scripts/wallet-tool.py $wallet display" | tee $tmp/jmaddresses
    ;;
    esac

    if grep -q "just restart this joinmarket application" $tmp/jmaddresses ; then

        enter_continue "$pink
        This always happens the first time you access the display function.
        Please hit enter to run the display command again.
        $orange"
        case $1 in
        a)
        docker exec -it joinmarket bash -c "/jm/clientserver/scripts/wallet-tool.py $wallet displayall" | tee $tmp/jmaddresses
        ;;
        *)
        docker exec -it joinmarket bash -c "/jm/clientserver/scripts/wallet-tool.py $wallet display" | tee $tmp/jmaddresses
        ;;
        esac

    fi

clear
sed -i '1,/[Mm]ixdepth/{/[Mm]ixdepth/!d}' $tmp/jmaddresses
sed -i -r 's/\x1B\[[0-9;]*[a-zA-Z]//g' $tmp/jmaddresses #removeds escape characters
sed -i '/^[Mm]ixdepth/i\\' $tmp/jmaddresses

#formatting...
x=$(echo $wallet | wc -c | awk '{print $1}')
y=$(( 49 - x ))
line=$(echo "############################################" | head -c $y)

sed -i "1i##################################### $wallet $line" $tmp/jmaddresses
echo "
####################################### END #########################################" | tee -a $tmp/jmaddresses >$dn
set_terminal_wide
less $tmp/jmaddresses

if [[ $copyjmdesktop == "true" ]] ; then
mv $tmp/jmaddresses $HOME/Desktop/jmaddresses.txt 
else
rm $tmp/jmaddresses >$dn 2>&1
fi

}

function check_wallet_loaded {
    if [[ $wallet == "NONE" ]] ; then
    announce "Please load wallet first"
    choose_wallet 
    else 
    return 0
    fi

    if [[ $wallet == "NONE" ]] ; then
    return 1 
    else
    return 0
    fi
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
enter_continue ; jump $enter_cont
return 0
}

function restore_jm_wallet {
while true ; do
set_terminal_custom 47 ; echo -e "
########################################################################################

    Wallet files will be kept inside the container at$cyan /root/.joinmarket/wallet $orange

    You will be asked to input your seed. Type it in and separate with spaces, then
    hit <enter>.

    It will then ask if you want to add a mnemonic extension. This means the 
    passphrase. Enter that in if your wallet has one.
    
    You will also be asked for a passphrase to encrypt the wallet - the wording is
    confusing. It actually means some PASSWORD to lock the wallet, not your actual
    wallet passphrase. Make it something strong and don't forget it. You (nor an
    attacker) can access the wallet file unless they now the password.

    You will then be asked to create a wallet file name - this doesn't have to be
    the same as the file name you once used for this wallet. It can be whatever.

    It will then ask:
$red
    Would you like this wallet to support fidelity bonds? Write 'n' if you don't 
    know what this is (y/n): 
$orange
    I personally have not investigated this feature enough to advise, so I'll be
    choosing 'n'. You do what you think is best. Type$cyan f$orange and $green<enter>$orange 
    now if you want more info on Fidelity Bonds (sourced from ChatGPT). TL;DR - It's a 
    privacy feature.

########################################################################################
"
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
f) fidelity_bonds_info ;;
*)
break ;;
esac
done

> $dp/before ; > $dp/after #clear contents
#copy list of wallets to before file
for i in $(ls $HOME/.joinmarket/wallets/) ; do echo "$i" >> $dp/before 2>/dev/null ; done
docker exec -it joinmarket bash -c "/jm/clientserver/scripts/wallet-tool.py recover" 
#copy list of wallets to after file
for i in $(ls $HOME/.joinmarket/wallets/) ; do echo "$i" >> $dp/after 2>/dev/null ; done
#automatically export the new wallet
export wallet=$(diff $dp/before $dp/after | grep ">" | awk '{print $2}')
#show wallet summary
docker exec -it joinmarket bash -c "/jm/clientserver/scripts/wallet-tool.py $wallet summary" 
enter_continue
#clear before and after files
> $dp/before ; > $dp/after
}

function delete_lockfile {

while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
    Explanation about lock files.
$orange 
    When JoinMarket uses a wallet, it creates a an empty file called a 'lock file' as 
    signal to itself, in case a second instance of JoinMarket tries to use the same 
    wallet - that'd cause bad things to happen. Whenever a wallet is about to be used
    it checks for the existance of a lock file and proceeds only if one does not
    exist. Whenever it is finished with a wallet, it deletes the lock file.

    Sometimes if there is a crash, the joinmarket software doesn't have a chance
    to clean up after itself and the lock file remains. Then, if JoinMarket is run
    again, it can't proceed because the lock file exists. 

    In such situations, the lock file needs to be deleted. If you are sure there is
    no other instance of JoinMarket using the wallet, you can delete the lockfile
    either manually or let Parmanode do it for you. 
    
    Below are the lockfiles (if any)...$bright_blue
    "
   
    cd $HOME/.joinmarket/wallets >$dn 2>&1
    for i in $(ls -a) ; do echo $i ; done | grep lock | sed 's/^/    /' | tee $tmp/jm_lockfiles
    cd - >$dn 2>&1

    echo -en " $red
    You can type in the file name exactly if you want parmanode to delete it.$orange
    Otherwise hit $cyan<enter>$orange to get out of here.

########################################################################################
"
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
esac

if ! echo $choice | grep -iq lock ; then
    announce "$choice is probably a typo. Try again."
    continue
else
    sudo rm -rf $HOME/.joinmarket/wallets/$choice
    enter_continue
    return 0
fi
done

}

function backup_jm_wallet {

while true ; do
set_terminal ; echo -e "
########################################################################################

    The following is a list of the contents of$cyan $HOME/.joinmarket/wallets/:
    
$red
$(ls $HOME/.joinmarket/wallets/)
$orange

    Please type in exactly the filename of the wallet you wish to backup. Parmanode
    will copy the file (not move, but copy) to your desktop. It'll be easy for you
    to see it there and then you can simply save it to where you want. 

$orange
########################################################################################
"
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
*)

[[ $choice =~ ^/ ]] && invalid && continue

if [[ -e $HOME/Desktop/$choice ]] ; then
announce "The file seems to exist on the Desktop already. Please move it or delete it
    first." && continue
fi

sudo cp $HOME/.joinmarket/wallets/$choice $HOME/Desktop/$choice
enter_continue
return 0
;;
esac
done
}


function wallet_history_jm {
check_wallet_loaded || return 1
docker exec -it joinmarket bash -c "/jm/clientserver/scripts/wallet-tool.py $wallet history" 
enter_continue
}


function choose_wallet {
cd $HOME/.joinmarket/wallets >$dn 2>&1 || return
set_terminal ; echo -e "
########################################################################################

    Please choose a wallet, type the file name exaclty, then <enter>
"
>$dp/.jmwallets
for i in $(ls) ; do echo -e "    $red$i$orange" ; echo "$i" | tee -a $dp/.jmwallets >/dev/null 2>&1 ; done
cd - >$dn 2>&1
echo -en "
$orange
########################################################################################
"
read wallet
if ! grep -q "$wallet" $dp/.jmwallets ; then 
announce "This is not a valid wallet"
export wallet="NONE"
return 1
fi
export wallet
}
