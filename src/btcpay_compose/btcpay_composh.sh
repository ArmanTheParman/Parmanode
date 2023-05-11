function install_btcpay_compose {
sudo su -

# Create a folder for BTCPay
mkdir $HOME/parmanode/btcpayserver
cd $HOME/parmanode/btcpayserver

git clone https://github.com/btcpayserver/btcpayserver-docker
cd btcpayserver-docker

get_IP

export BTCPAY_HOST="$IP"
export NBITCOIN_NETWORK="mainnet"
export BTCPAYGEN_CRYPTO1="btc"
export BTCPAYGEN_ADDITIONAL_FRAGMENTS="opt-save-storage-xs"
export BTCPAYGEN_REVERSEPROXY="empty"
export BTCPAYGEN_LIGHTNING="lnd"
export BTCPAY_ENABLE_SSH=true
. ./btcpay-setup.sh -i

exit
}


