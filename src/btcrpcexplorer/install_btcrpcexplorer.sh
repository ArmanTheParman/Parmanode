# install_btcexplorer
# confugure_btcrpcexplorer
# btcrpcexplorer_questions
# make_btcrpcexplorer_config
# make_btcrpcexplorer_service


function install_btcrpcexplorer {
set_terminal
if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi
if [[ $chip != "x86_64" ]] ; then return 1 ; fi

install_nodejs || return 1

installed_config_add "btcrpcexplorer-start" 

cd $HOME/parmanode
git clone https://github.com/janoside/btc-rpc-explorer.git
cd btc-rpc-explorer

sudo npm install -g btc-rpc-explorer

installed_config_add "btcrpcexplorer-end"

configure_btcrpcexplorer

debug "configure done"

btcrpcexplorer_questions

make_btcrpcexplorer_config

make_btcrpcexplorer_service

debug "install done"

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

set_terminal
echo "
########################################################################################

    Parmanode can configure BTC RPC Explorer to give you a better experience.

                Is your computer relatively fast?    y or n

    If it's a year or two old, then it probably is fast enouth to choose yes.

########################################################################################
"
read choice

if [[ $choice == "y" ]] ; then export fast_computer="yes" ; else fast_computer="false" ; fi


}

function make_btcrpcexplorer_config {

source ~/.bitcoin/bitcoin.conf >/dev/null
source ~/.parmanode/parmanode.conf >/dev/null

if [[ $fast_computer == "yes" ]] ; then
    echo "BTCEXP_SLOW_DEVICE_MODE=false" > $HOME/parmanode/btc-rpc-explorer/.env 
else
    echo "BTCEXP_SLOW_DEVICE_MODE=true" > $HOME/parmanode/btc-rpc-explorer/.env 
fi
debug "btc auth - $btc_authentication"
if [[ $btc_authentication == "user/pass" ]] ; then
    echo "BTCEXP_BITCOIND_USER=$rpcuser" >> $HOME/parmanode/btc-rpc-explorer/.env 
    echo "BTCEXP_BITCOIND_PASS=$rpcpassword" >> $HOME/parmanode/btc-rpc-explorer/.env 
else
    echo "BTCEXP_BITCOIND_COOKIE=$HOME/.bitcoin/.cookie" >> $HOME/parmanode/btc-rpc-explorer/.env 
fi

echo "BTCEXP_BITCOIND_RPC_TIMEOUT=50000" >> $HOME/parmanode/btc-rpc-explorer/.env 
echo "BTCEXP=0.0.0.0" >> $HOME/parmanode/btc-rpc-explorer/.env 
echo "BTCEXP_ADDRESS_API=electrumx" >> $HOME/parmanode/btc-rpc-explorer/.env 
echo "BTCEXP_ELECTRUMX_SERVERS=tcp://127.0.0.1:50001" >> $HOME/parmanode/btc-rpc-explorer/.env 
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