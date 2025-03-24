return 0
#Bitcoin curl Command:
from inside podman to 127 host outside...
curl --user rpcuser:rpcpassword --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getblockchaininfo", "params": [] }' -H 'content-type: text/plain;' http://node-ip:8332


#Fulcrum
from outside podman to fulcrum inside
curl --user rpcuser:rpcpassword --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getbestblockhash", "params": [] }' -H 'content-type: text/plain;' http://172.17.0.2:50001/
