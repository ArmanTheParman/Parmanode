function getblockheight {
source $HOME/.bitcoin/bitcoin.conf >/dev/null 2>&1

if [[ $OS == Mac ]] ; then
export blockheight=$(curl -s --user $rpcuser:$rpcpassword --data-binary '{"jsonrpc": "1.0", "id":"curltest", \
"method": "getblockchaininfo", "params": [] }' -H 'content-type: text/plain;' \
http://127.0.0.1:8332/ | grep -oE 'blocks":.+$' | cut -d , -f 1 | cut -d : -f 2)
else
export blockheight=$(/usr/local/bin/bitcoin-cli getblockchaininfo | grep blocks | grep -oE '[0-9].+$' \
| cut -d , -f 1)
fi
}