function add_server_1_to_bitcoinconf { debugf
if grep -q "bitcoin-end" $ic ; then
if ! grep -q "server=1" $bc ; then
set_terminal ; echo -e "
########################################################################################
    
    Bitcoin needs to be restarted to add the line$cyan 'server=1'$orange to the config file.

    Hit$red s$orange to skip or$green anything else$orange to continue and allow the changes to be made.

########################################################################################
"
read choice
if [[ $choice == "s" ]] ; then return ; fi

    stop_bitcoin
    echo "server=1" | tee -a $bc >$dn 2>&1
    start_bitcoin
fi
fi
}

function bitcoin_byo { debugf
set_terminal ; echo -e "
########################################################################################
$cyan
             How to bring in your existing Bitcoin data from another drive.
$orange
    If your data is from Umbrel, Mynode, or RaspiBlitz, then it's better to abort
    and use the custom import drive function.

    To import your exiting Bitcoin data on a non-Parmanode drive, do the following: 
$green
        1)$orange   Label your drive as 'parmanode' - this is important for detection
             and preventing errors later.
        
$green        2)$orange   Make a directory called '.bitcoin' at the root of the drive. Don't
             forget the dot, indicating it's a hidden directory.

$green        3)$orange   Copy your bitcoin data into this directory. If you need help with that
             you probably shouldn't be attempting this. Also, you may consider 
             using the Parmanode rsync helper tool in the Tools menu for reliable 
             copying of data and file attributes; it's also possible to copy the data
             from another computer of SSH using this tool. Do make sure any copying 
             of Bitcoin data happens when Bitcoin itself is not running or the data
             will certainly become corrupted. No joke.              

$green        4)$orange   From this point, repeat the Bitcoin installation and select
             'import Parmanode drive' because that's what it effectively is now.
       
$orange
########################################################################################
"
enter_continue
jump $enter_cont
}
function bitcoin_curl { debugf
source $bc

while true ; do
set_terminal ; echo -en "
########################################################################################

    The curl command to the bitcoin daemon, to run in terminal is...
$cyan

curl --user $rpcuser:$rpcpassword --data-binary '{\"jsonrpc\": \"1.0\", \"id\":\"curltest\", \"method\": \"getblockchaininfo\", \"params\": [] }' -H 'content-type: text/plain;' http://$IP:8332
$orange
    Parmanode can run this command for you or you can copy/paste it yourself, and
    make edits as needed.
$green
               d)      Do it for me
$orange
            <enter>    I'll do it, moving on.

########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
set_terminal
case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; M|m) back2main ;;
"") break ;;
d)
curl --user $rpcuser:$rpcpassword --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getblockchaininfo", "params": [] }' -H 'content-type: text/plain;' http://$IP:8332
enter_continue
break
;;
*)
invalid
;;
esac
done
}

function getblockheight { debugf
source $HOME/.bitcoin/bitcoin.conf >$dn 2>&1

if [[ $OS == "Mac" ]] ; then
export blockheight=$(curl -s --user $rpcuser:$rpcpassword --data-binary '{"jsonrpc": "1.0", "id":"curltest", \
"method": "getblockchaininfo", "params": [] }' -H 'content-type: text/plain;' \
http://127.0.0.1:8332/ | grep -oE 'blocks":.+$' | cut -d , -f 1 | cut -d : -f 2)
else
export blockheight=$(/usr/local/bin/bitcoin-cli getblockchaininfo | grep blocks | grep -oE '[0-9].+$' \
| cut -d , -f 1)
fi
}



function bitcoin_tips { debugf
set_terminal_high ; echo -e "
########################################################################################$cyan
                          Parmanode Bitcoin Usage Tips$orange
########################################################################################


    It's nice to see what Bitcoin is up to in real time. Check out the log from the
    menu. If the log menu is playing up, you can look at it manually with $cyan
    nano $HOME/.bitcoin/debug.log$orange

    The information like the block height is captured from the debug.log file. It can
    glitch, no big deal, you can just look at the log and read the progress. The
    file populates with the newest additions at the bottom. When you see$cyan
    progress=1.00000000$orange, you know it's fully synced.

    If you have data corruption, Bitcoin will fail to start. Read the log file and 
    see if it indicates data corruption - you'll have to delete and resync. Parmanode
    Bitcoin menu has a tool for that.

    If you are having trouble starting/stopping bitcoin, you can try doing it manually.
    In Mac, use the GUI - click the icon in the Applications menu. In Linux, do$cyan 
    sudo systemctl COMMAND bitcoind$orange. Replace COMMAND with start, stop, restart, 
    or status.
    
    In you're using the BTCPay combo docker container, restarting the container 
    manually will be problematic, because the numerous programs do not automatically 
    load up if the container is simply restarted. Instead, you can manually enter the 
    container, do$cyan pkill -15 bitcoind$orange, and restart it with
    
        $cyan bitcoind -conf=/home/parman/.bitcoin/bitcoin.conf$orange

    If you want to move the data directory somewhere else, first have a look at the
    ${cyan}dfat$orange menu option in Parmanode-->Tools, and glean from there how the symlinks
    work. To move or copy the data directory, make sure Bitcoin has been stopped. Then
    use the$cyan rysync$orange tool from the Parmanode-->Tools menu. It will help you 
    construct the correct command.


########################################################################################
"
choose xpmq ; read choice
jump $choice || { invalid ; continue ; }
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
*)
return 0 
;;
esac

}

function check_rpc_bitcoin { debugf
unset rpcuser

source $pc

if [[ $bitcoin_choice_with_lnd == "remote" ]] ; then return 0 ; fi
if [[ $bitcoin_choice_with_litd == "remote" ]] ; then return 0 ; fi

source $HOME/.bitcoin/bitcoin.conf >$dn 2>&1
if [ -z $rpcuser ] ; then
set_terminal ; echo -e "
########################################################################################    

    The program won't work unless Bitcoin has a username and password set.

    Would you like to set that now?    
    
                      $green           y$orange   or $red   n $orange

######################################################################################## 
"    
read choice

    case $choice in 
    y|Y|YES|Yes|yes) 
    please_wait ; set_rpc_authentication "s" && return 0
    return 1
    ;;
    esac
fi
return 0
}