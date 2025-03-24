#podman_dir=$(podman volume inspect generated_btcpay_datadir --format="{{.Mountpoint}}" | sed -e "s%/volumes/.*%%g")
#backup_dir="$podman_dir/volumes/backup_datadir/_data"
#/var/lib/podman/volumes/generated_btcpay_datadir# 
#podman info | grep "Storage Driver"

function do_backup_btcpay {
sudo tar \
    --exclude="volumes/backup_datadir" \
    --exclude="volumes/generated_btcpay_datadir/_data/host_*" \
    --exclude="volumes/generated_bitcoin_datadir/_data" \
    --exclude="volumes/generated_litecoin_datadir/_data" \
    --exclude="volumes/generated_elements_datadir/_data" \
    --exclude="volumes/generated_xmr_data/_data" \
    --exclude="volumes/generated_dogecoin_datadir/_data/blocks" \
    --exclude="volumes/generated_dogecoin_datadir/_data/chainstate" \
    --exclude="volumes/generated_dash_datadir/_data/blocks" \
    --exclude="volumes/generated_dash_datadir/_data/chainstate" \
    --exclude="volumes/generated_dash_datadir/_data/indexes" \
    --exclude="volumes/generated_dash_datadir/_data/debug.log" \
    --exclude="volumes/generated_mariadb_datadir" \
    --exclude="volumes/generated_postgres_datadir" \
    --exclude="volumes/generated_electrumx_datadir" \
    --exclude="volumes/generated_lnd_bitcoin_datadir/_data/data/graph" \
    --exclude="volumes/generated_clightning_bitcoin_datadir/_data/lightning-rpc" \
    --exclude="**/logs/*" \
    -cvzf $HOME/Desktop/backup.tar $(sudo find /var/lib/podman/volumes/ -name "generated_*")
printf "\n"
echo "Desktop contents...

$(ls $HOME/Desktop)
"
enter_continue
}