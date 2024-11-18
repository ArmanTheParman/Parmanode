#docker_dir=$(docker volume inspect generated_btcpay_datadir --format="{{.Mountpoint}}" | sed -e "s%/volumes/.*%%g")
#backup_dir="$docker_dir/volumes/backup_datadir/_data"
#/var/lib/docker/volumes/generated_btcpay_datadir# 
