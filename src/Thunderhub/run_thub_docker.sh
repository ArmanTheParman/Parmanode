function run_thub_docker {
docker run -d --name thunderhub -p $thub_port:3000/tcp \
              --restart unless-stopped \
              -v $hp/thunderhub/account_1.yaml:/app/account_1.yaml \
              -v $hp/thunderhub/.env.local:/app/.env.local \
              -v $HOME/.lnd/data/chain/bitcoin/mainnet/:/home/parman/.lnd/data/chain/bitcoin/mainnet/ \
              -v $HOME/.lnd/tls.cert:/home/parman/.lnd/tls.cert \
              thunderhub || runfailed="true"

echo "pausing to see if run command successful"
enter_continue
if [[ $runfailed == "true" ]] ; then 
announce "Something went wrong. Aborting."
unset runfailed ; return 1 ; fi
}

#-v 3010:3010 \