
function upgrade_to_knots {
#confirmation
yesorno "
    Bitcoin Knots is basically the contributions of all Bitcoin Core developers,
    except, instead of the 5 seemingly compromised people that have final say 
    with Bitcoin Core's GitHub repository keys, it is Luke Dashjr who has the 
    final'veto', and he probably should be Bitcoin Core's lead developer anyway.

    If you proceed, the current Bitcoin binary files will be swapped with the
    latest Knots binaries. The blockchain and bitcoin.conf file will not be
    modified.

    Bitcoin will work just like before, but your node will not rely spam
    from mempool to mempool, and if you are running on clearnet (options
    1 or 4 from the bitcoin tor menu), then your node will be counted and
    you'll contribute to sending a message.

    To read a collection of Parman's war Tweets, please visit this link
    which is the beginning of a chain of Tweets I put in my Twitter Highlights
    section for easy access:
$cyan
    https://x.com/parman_the/status/1966540916530745816
$orange
    Proceed?" || return 1
clear
stop_bitcoin
sudo rm -rf $hp/bitcoin
mkdir -p $hp/bitcoin
#download binaries, exract to directory, swap old with new.
knotsbitcoin="true"
export clientchoice="knots" 
export knotsversion="29.1"
export deisversion="28.1"
export knotsdate="20250903"
export knotstag="v${knotsversion}.knots${knotsdate}"
export knotsmajor="29.x"
export knotsextension="tar.gz"
cd $hp/bitcoin
download_bitcoin_getfiles || { enter_continue "Something went wrong." ; return 1 ; }
parmanode_conf_remove "bitcoin_choice"
parmanode_conf_add "bitcoin_choice=knots"
verify_bitcoin || return 1
sudo mkdir -p /usr/local/bin/bitcoin_old
sudo mv /usr/local/bin/*bitcoin* /usr/local/bin/bitcoin_old/
unpack_bitcoin || return 1
start_bitcoin
Success "Bitcoin has been upgraded to Knots."
}
