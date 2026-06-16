
function make_cln_config {

bitcoin__rpcport="$(cat $HOME/.bitcoin/bitcoin.conf | grep rpcport | tail -n 1 | cut -d = -f 2)" #no hyphens in bash variables
bitcoin__rpcport=${bitcoin__rpcport:-8332} #default

random=$(dd if=/dev/urandom bs=1 count=50 2>/dev/null)
aliasrand=$(echo "$random $(date)" | shasum -a 256 | sed -E 's/^(.{15}).*$/\1/')

announce-addr-discovered-port
cat <<EOF | tee $HOME/.lightning/config >$dn 2>&1
#daemon --don't use daemon if using systemd service file
log-file=$HOME/.lightning/log
network=bitcoin
bitcoin-cli=$(which bitcoin-cli)
bitcoin-datadir=$HOME/.bitcoin
bitcoin-rpcuser=$(cat $HOME/.bitcoin/bitcoin.conf | grep rpcuser | cut -d = -f 2)
bitcoin-rpcpassword=$(cat $HOME/.bitcoin/bitcoin.conf | grep rpcpassword | cut -d = -f 2)
bitcoin-rpcconnect=127.0.0.1
bitcoin-rpcport=$bitcoin__rpcport
alias=BananaStand_$aliasrand
clnrest-port=3777
clnrest-host=127.0.0.1
#fee-base=MILLISATOSHI
#fee-per-satoshi=MILLIONTHS
#min-capacity-sat=SATOSHI

#If LND running, port 9735 and maybe 9736 are in use. Need these...
#grpc-port=9738
#bind-addr=0.0.0.0:9737
EOF
return 0
}