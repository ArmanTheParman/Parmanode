function make_bitcoin_symlinks { debugf
set_terminal

while true ; do

if [[ $btcpayinstallsbitcoin == "true" ]] ; then return 0 ; fi

if [[ $OS == "Linux" ]] ; then

    #binaries will go into /usr/local/bin/parmanode
    #symlinks to binaries will go in /usr/local/bin, a root owned directory; this is the default path of make install for bitcoin.
    if [[ $parmaview == 1 ]] ; then
        sudo -E /usr/local/parmanode/p4run "delete_bitcoin_files"
    else 
        sudo rm -rf /usr/local/bin/*bitcoin*
    fi

    symlinks_for_bitcoin_binaries
fi

if [[ $OS == "Linux" && $drive == "internal" ]] ; then
    return 0 
    #no symlink needed
fi

if [[ $OS == "Linux" && $drive == "external" ]] ; then
    
    #check if non-symlink bitcoin dir exists in target location
    if test -e $HOME/.bitcoin && ! test -L $HOME/.bittcoin ; then
        btemp="$HOME/.bitcoin_$(shasum -a 256 <<<$(date) | cut -c1-8)" 
        mv $HOME/.bitcoin $btemp >$dn 2>&1
        announce "A bitcoin directory already exists in the internal file system. It has been
        \r    moved to$cyan $btemp$orange"
    fi 

    cd $HOME && ln -s /media/$(whoami)/parmanode/.bitcoin/ .bitcoin  
    break  #symlink can be made without errors even if target doesn't exist yet
fi

if [[ $OS == "Mac" && $drive == "internal" ]] ; then
    cd $HOME/Library/"Application Support"/ ; rm -rf  Bitcoin
    cd $HOME/Library/"Application Support"/ && ln -s $HOME/.bitcoin Bitcoin 
    break
fi

if [[ $OS == "Mac" && $drive == "external" ]] ; then
    cd $HOME/Library/Application\ Support/ >$dn 2>&1 && rm -rf Bitcoin >$dn 2>&1 
    cd $HOME && rm -rf .bitcoin >$dn 2>&1 
    cd $HOME/Library/Application\ Support/ && ln -s /Volumes/parmanode/.bitcoin Bitcoin && \
    cd $HOME && ln -s $parmanode_drive/.bitcoin .bitcoin 
    break
fi
done

if [[ $btcdockerchoice != "yes" && $btcpayinstallsbitcoin != "true" ]] ; then
set_terminal ; echo -e "
########################################################################################

                                $cyan 
                                 Symlinks created
$orange
    NOTHING TO DO, IT'S JUST FOR YOUR INFORMATION IN CASE YOU WANT IT.

    A symlink to the data directory has been created.

    For external drives, $HOME/.bitcoin points to

$green
            $parmanode_drive/.bitcoin
$orange

    For Mac users with an internal drive, 
    $HOME/Library/Application Support/Bitcoin (the default location),
    now points to:

$green
            $HOME/.bitcoin
$orange

########################################################################################
"
enter_continue
fi #end btcdockerchoice

set_terminal
return 0
}

function symlinks_for_bitcoin_binaries { debugf
[[ $OS == "Linux" ]] || return 1

if [[ $parmaview == 1 ]] ; then sudo -E /usr/local/parmanode/p4run "bitcoin_binary_symlinks" ; return 0 ; fi
sudo mkdir -p /usr/local/bin/parmanode/
sudo ln -s  /usr/local/bin/parmanode/bitcoin-cli /usr/local/bin/bitcoin-cli >$dn 2>&1
sudo ln -s  /usr/local/bin/parmanode/bitcoind /usr/local/bin/bitcoind >$dn 2>&1
sudo ln -s  /usr/local/bin/parmanode/bitcoin-qt /usr/local/bin/bitcoin-qt >$dn 2>&1
sudo ln -s  /usr/local/bin/parmanode/bitcoin-tx /usr/local/bin/bitcoin-tx >$dn 2>&1
sudo ln -s  /usr/local/bin/parmanode/bitcoin-util /usr/local/bin/bitcoin-util >$dn 2>&1
sudo ln -s  /usr/local/bin/parmanode/bitcoin-wallet /usr/local/bin/bitcoin-wallet >$dn 2>&1
sudo ln -s  /usr/local/bin/parmanode/test-bitcoin /usr/local/bin/test-bitcoin >$dn 2>&1
}