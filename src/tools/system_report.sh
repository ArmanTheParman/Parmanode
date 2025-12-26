function system_report {

clear ; echo -e "
########################################################################################

    Parmanode will generate a System Report File automatically. It will
    then save the file to your desktop, and you can then email it to me for help.

    You could also also do a screen video recording of the problem. There
    is an option to do that in the tools menu.
    
    Hit$cyan <enter>$orange to continue

$red    'a'$orange and$cyan <enter>$orange to abort

########################################################################################
"
read -s choice ; clear
jump $choice 
case $choice in
a|q|Q) 
exit 
;;
esac

export omit="true" 
export report="$tmp/system_report.txt" 
export macprefix="/usr/local"
echor -e "########################################################################################"
echo -e "PARMANODL SYSTEM REPORT $(date)", $(head -n1 $pn/version.conf | sed 's/\"//g' | cut -d = -f 2) > $report
echor -e "########################################################################################\n"

heading "PN DIRECTORY CHECK"
if [[ -d $HOME/parman_programs/parmanode ]] ; then
echor "\$pn exists"
else
echor "\$pn DOES NOT EXIST"
fi

heading "GIT"
echor "$(git status)"

heading "DOT PARMANODE DIRECTORY CHECK"
if [[ -d $HOME/.parmanode ]] ; then
echor "\$dp exists\n contents:\n"
cd $HOME/.parmanode
ls -am >> $report
else
echor "\$dp DOES NOT EXIST"
fi

if [[ $OS == "Mac" ]] ; then
heading "MAC TESTS"
echor "which brew: $(which brew)"
echor "which gsed: $(which gsed)"
echor "Home dir: $(echo $HOME)"
fi

heading "HOME PARMANODE"
cd $HOME/parmanode
echor "$(ls -m)"

heading "/usr/local/parmanode"
cd "/usr/local/parmanode"
echo "$(sudo ls -lah)"

heading "/usr/local/bin"
cd "/usr/local/bin"
echo "$(sudo ls -lah)"

heading "/usr/local/parmanode"
cd "/usr/local/parmanode"
echo "$(sudo ls -lah)"

heading "EXTERNAL DRIVE"
if [[ $OS == "Linux" ]] ; then echor "$(mountpoint $pd)" ; fi
if [[ $OS == "Mac" ]] ; then echor "$(diskutil list)" ; fi
echor "$(cd $pd ; ls -ma)"


heading "LOG COUNTER"
echor "$(cat $dp/log_counter.conf)"

heading "PARMANODE.CONF"
echor "$(cat $dp/parmanode.conf)"

heading "INSTALLED.CONF"
echor "$(cat $dp/installed.conf)"

heading "PROGRAM CHECK"
echor "which nginx npm tor bitcoin-cli docker brew curl jq netstat tmux ssh:"
echor "$(sudo which nginx npm tor bitcoin-cli docker brew curl jq netstat tmux ssh)"

heading "TMUX LIST..."
echor "$(tmux ls)"

heading "ELECTRUM CONNECTION"
echor "$(cat $dp/electrum.connection)"

heading "NGINX" 
echor "$(sudo nginx -t)"
cd "$macprefix/etc/nginx" && echor "$(pwd ; ls -m)"
cd "$macprefix/etc/nginx/conf.d" && echor "$(pwd ; ls -m)"
echor "$(file \"\$macprefix/etc/nginx/stream.conf\" && cat \"/etc/nginx/stream.conf\")"
echor "$(file \"\$macprefix/etc/nginx/nginx.conf\" && cat \"/etc/nginx/nginx.conf\")"

heading "NGINX ERROR FILE..."
echor "$(cat $tmp/nginx.conf_error)"

heading "BITCOIN"
echor "IP is $IP"
if [[ ! -e $HOME/.bitcoin ]] ; then echor "Bitcoin data dir doesn't exist." 
else
cd $HOME/.bitcoin
echor ".bitcion size..."
echor "$(du -sh)"
echor ".bitcoin contents..."
echor "$(ls -m)"
echor "bitcoin.conf..."
echor "$(cat $HOME/.bitcoin/bitcoin.conf)"
echor "Journalctl -exu bitcoind"
echor "$(journalctl -exu bitcoind | tail -n100)"
echor "getblockchaininfo..."
echor "$(bitcoin-cli getblockchaininfo)"
fi

heading "DOCKER ..."
echor "docker ps -a \n $(docker ps -a)"
echor "docker ps \n $(docker ps) \n "
containers=$(docker ps -q)
echor "containers... \n $(docker ps -q)"
for i in $containers ; do
docker logs $i --tail 50 
done

heading "BTCRPCEXPLORER"
echor "env \n $(cat $HOME/parmanode/btc-rpc-explorer/.env)"

heading "BTCPAY"
echor "btcpay \n $(cat $HOME/.btcpayserver/Main/settings.config)"
echor "nbxplorer \n $(cat $HOME/.nbxplorer/Main/settings.config)"

heading "ELECTRS"
echor "electrs config \n $(cat $HOME/.electrs/config.toml)"
echor "ELECTRS_STREAM_FILE \n $(cat $tmp/nginx.conf_error)"

heading "ELECTRUMX"
echor "elecrrumx config \n $(cat $HOME/parmanode/electrumx/electrumx.conf)"

heading "FULCRUM"
echor "fulcrum config \n $(cat $fc)"

heading "LND"
echor "LND config \n $(cat $HOME/.lnd/lnd.conf)"
if [[ $OS == "Linux" ]] ; then echor "$(journalctl -exu lnd.service)" ; fi

heading "MEMPOOL"
echor "Mempool docker compose \n $(cat $hp/mempool/docker/docker-compose.yml)"

heading "TOR"
echor "$(which tor)"
echor "$(sudo cat $torrc | sed '/^#/d')"

heading "THUNDERHUB"
echor "$(sudo cat $hp/thunderhub/account_1.yaml)"
echor ".env.locl contents"
echor "$(sudo cat $hp/thenderhub/.env.local | sed '/^#.*$/d' | sed '/^$/d')"

heading "SYSTEM INFO"
if [[ $(uname) == Darwin ]] ; then echor "$(system_profiler SPHardwareDataType)" ; fi
echor "$(id)"
echor "$(uname) , $(uname -m)"
echor "$(env)"
echo -e "----------------------------------------------------------------------------------------" >> $report
echor "$(df -h)"
echo -e "----------------------------------------------------------------------------------------" >> $report
echor "$(sudo lsblk)"
echor "$(sudo blkid)"
echo -e "----------------------------------------------------------------------------------------" >> $report
echor "#MOUNT \n $(mount)"
echo -e "----------------------------------------------------------------------------------------" >> $report
echor "$(free)"
echo -e "----------------------------------------------------------------------------------------" >> $report
echor "#HOME dir..."
echor "$(cd ; ls -lah)"
echo -e "----------------------------------------------------------------------------------------" >> $report
echor "cpuinfo"
echor "$(cat /proc/cpuinfo | head -n20)"
echo -e "----------------------------------------------------------------------------------------" >> $report

heading "BASHRC/ZSHRC tail 30"
echor "$(sudo cat $bashrc | tail -n30)"

delete_private
clear
mkdir -p $HOME/Desktop/ >/dev/null 
sudo mv $report $HOME/Desktop/ || enter_continue 

sleep 2
clear ; echo -e "
########################################################################################

    Parmanode has generated a system report about your installation, and left the
    file for you at: $cyan

    $HOME/Desktop/system_report.txt  $orange 
    
    You can now review this file, and if you were asked, can send this to Parman
    for assistance. The email is:
$cyan
    armantheparman@protonmail.com
$orange
    A note for$pink Ubuntu$orange users - File in the Desktop directory to show up on your 
    desktop. It's weird, I don't know why Ubuntu does that. You can access the file
    from the file explorer instead.

    Hit$cyan <enter>$orange to finish.

########################################################################################
"
read
}

function delete_private {
if [[ $omit == "true" ]] ; then
    rm $dp/sed.log >$dn
    rm $dp/debug.log >$dn
    rm $dp/change_string* >$dn
    if which gsed >$dn ; then
      cat $report | gsed '/coreAuth/d; /BTCEXP_BITCOIND/d; /rpcuser/d; /rpcpass/d; /auth = /d; /btc\.rpc\.user=/d; /btc\.rpc\.password=/d; /alias=/d; /bitcoind\.rpc/d; /DAEMON_URL =/d; /CORE_RPC_USERNAME/d; /CORE_RPC_PASSWORD/d; /BITCOIN_RPC_PASSWORD/d; /BITCOIN_RPC_USER/d; /multiPass/d' > $tmp/tempreport 
    elif which sed >$dn ; then
      cat $report | sed '/coreAuth/d; /BTCEXP_BITCOIND/d; /rpcuser/d; /rpcpass/d; /auth = /d; /btc\.rpc\.user=/d; /btc\.rpc\.password=/d; /alias=/d; /bitcoind\.rpc/d; /DAEMON_URL =/d; /CORE_RPC_USERNAME/d; /CORE_RPC_PASSWORD/d; /BITCOIN_RPC_PASSWORD/d; /BITCOIN_RPC_USER/d; /multiPass/d' > $tmp/tempreport 
    fi
mv $tmp/tempreport $report
fi
}

function heading {
echo -e "\n----------------------------------------------------------------------------------------" >> $report
echo -e "##########################   $1   ####################################" >> $report
echo -e "----------------------------------------------------------------------------------------\n" >> $report
}

function echor {
echo -e "$1" >> $report 2>&1
}

