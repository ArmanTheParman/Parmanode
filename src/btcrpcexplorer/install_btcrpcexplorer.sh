# install_btcexplorer
# confugure_btcrpcexplorer
# btcrpcexplorer_questions
# make_btcrpcexplorer_config
# make_btcrpcexplorer_service


function install_btcrpcexplorer {
set_terminal
if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi
if [[ $(uname -m) != "x86_64" ]] ; then 
set_terminal ; echo -e "
########################################################################################

       For$cyan x86_64$orange machines only. Your machine is $(uname -m).
       Please send a bug report if something is wrong.

########################################################################################
" ; enter_continue
return 1
fi

if ! cat $HOME/.parmanode/installed.conf | grep fulcrum-end >/dev/null ; then 
    set_terminal ; echo "
########################################################################################

    Be Warned, BTC RPC Explorer won't work unless you installed Bitcoin$cyan and either$orange 
    Fulcrum server or electrs server first. You could, instead modify the 
    configurtion file and point it to a Fulcrum or Electrum Server on this or 
    another machine.

    Proceed anyway?   y  or  n

########################################################################################
"
    read choice

    if [[ $choice != "y" ]] ; then return 1 ; fi
fi


install_nodejs || return 1

installed_config_add "btcrpcexplorer-start" 

cd $HOME/parmanode
git clone --depth 1 https://github.com/janoside/btc-rpc-explorer.git
cd btc-rpc-explorer

sudo npm install -g btc-rpc-explorer

installed_config_add "btcrpcexplorer-end"

configure_btcrpcexplorer

debug "configure done"

btcrpcexplorer_questions

make_btcrpcexplorer_config

make_btcrpcexplorer_service


success "BTC RPC Explorer" "being installed."
return 0
}

function configure_btcrpcexplorer {
#for older versions of Parmanode...
if cat $HOME/.parmanode/parmanode.conf | grep -q "btc_authentication" ; then return 0 ; else
    if cat $HOME/.bitcoin/bitcoin.conf | grep -q "rpcuser=" ; then export btc_authentication="user/pass" ; else export btc_authentication="cookie" ; fi
    parmanode_conf_remove "btc_authentication"
    parmanode_conf_add "btc_authentication=$btc_authentication"
fi
}

function btcrpcexplorer_questions {

if ! which dmidecode ; then sudo apt-get install dmidecode ; fi

biosDate=$(dmidecode -t bios | grep Date | cut -d / -f 3)

if [[ $biosDate -lt 2017 ]] ; then 
if [[ -n "$biosDate" && "$biosDate" =~ ^[0-9]{4}$ && $biosDate -lt 2017 ]]; then 
export fast_computer=false
elif [[ -n "$biosDate" && "$biosDate" =~ ^[0-9]{4}$ && $biosDate -ge 2017 ]]; then
export fast_computer=true
else

set_terminal
echo "
########################################################################################

    Parmanode can configure BTC RPC Explorer to give you a better experience during
    the installation.

    Is your computer probably older than 6 years? $cyan   y  or  n $orange

########################################################################################
"
choose "x"
read choice

if [[ $choice == "y" ]] ; then export fast_computer="yes" ; else fast_computer="false" ; fi
fi
}

function make_btcrpcexplorer_config {

source ~/.bitcoin/bitcoin.conf >/dev/null
source ~/.parmanode/parmanode.conf >/dev/null

if cat ~/.parmanode/installed.conf | grep -q electrs-end ; then eserver="tcp://127.0.0.1:50005" 
else eserver="tcp://127.0.0.1:50001"
fi

if [[ $fast_computer == "yes" ]] ; then
    echo "BTCEXP_SLOW_DEVICE_MODE=false" > $HOME/parmanode/btc-rpc-explorer/.env 
else
    echo "BTCEXP_SLOW_DEVICE_MODE=true" > $HOME/parmanode/btc-rpc-explorer/.env 
fi
if [[ $btc_authentication == "user/pass" ]] ; then
    echo "BTCEXP_BITCOIND_USER=$rpcuser" >> $HOME/parmanode/btc-rpc-explorer/.env 
    echo "BTCEXP_BITCOIND_PASS=$rpcpassword" >> $HOME/parmanode/btc-rpc-explorer/.env 
else
    echo "BTCEXP_BITCOIND_COOKIE=$HOME/.bitcoin/.cookie" >> $HOME/parmanode/btc-rpc-explorer/.env 
fi

echo "BTCEXP_BITCOIND_RPC_TIMEOUT=50000" >> $HOME/parmanode/btc-rpc-explorer/.env 
echo "BTCEXP=0.0.0.0" >> $HOME/parmanode/btc-rpc-explorer/.env 
echo "BTCEXP_ADDRESS_API=electrumx" >> $HOME/parmanode/btc-rpc-explorer/.env 
echo "BTCEXP_ELECTRUMX_SERVERS=$eserver" >> $HOME/parmanode/btc-rpc-explorer/.env 
echo "BTCEXP_NO_RATES=false" >> $HOME/parmanode/btc-rpc-explorer/.env 
}

function make_btcrpcexplorer_service {

echo "[Unit]
Description=BTC RPC Explorer
After=bitcoind.service
PartOf=bitcoind.service

[Service]
WorkingDirectory=$HOME/parmanode/btc-rpc-explorer
ExecStart=/usr/bin/btc-rpc-explorer
User=$USER

Restart=always
RestartSec=30

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/btcrpcexplorer.service

sudo systemctl enable btcrpcexplorer.service
}