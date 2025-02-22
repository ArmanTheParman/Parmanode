function custom_startup {
if echo $@ | grep -q test ; then
announce "no test available presently. Skipping."
fi

if echo $@ | grep -q fix ; then
announce "no fixes available presently. Skipping."
exit
fi

if [[ $bash == 1 && $OS == Linux ]] ; then 
#bash --rcfile <(source $HOME/.bashrc ; source $pn/source_parmanode.sh)
echo -e "Entering bash inception..."
sleep 0.5
bash --rcfile $pn/src/tools/rcfile
exit 
elif [[ $bash == 1 && $OS == Mac ]] ; then
echo -e "Entering bash inception..."
sleep 0.5
bash --rcfile $pn/src/tools/rcfile
exit 
fi

if [[ $uninstall_homebrew == true ]] ; then
uninstall_homebrew || exit
success "Homebrew uninstalled"
fi

if [[ $1 == "install_core_lightning" ]] ; then
install_core_lightning
exit
fi

if [[ $1 == "uninstall_core_lightning" ]] ; then
uninstall_core_lightning
exit
fi

if [[ $1 == pubkey ]] ; then
which qrencode || install_qrencode silent
set_terminal_high
echo "public key..."
qrencode -t ANSIUTF8 "$(cat ~/.ssh/id_rsa.pub)"
echo "onion address..."
qrencode -t ANSIUTF8 "$(sudo cat /var/lib/tor/parmanode-service/hostname)"
echo "Take a photo and send to Parman for ParMiner access"
enter_continue
exit
fi


if [[ $1 == mempoolerror ]] ; then
announce "About to gather information for mempool error and will save to Desktop/report.txt"
docker ps > $Desktop/report.txt 2>&1
echo "##1##" >> $Desktop/report.txt
docker logs docker-api-1 >> $Desktop/report.txt 2>&1
echo "##2##" >> $Desktop/report.txt
docker logs docker-db-1 >> $Desktop/report.txt 2>&1
echo "##3##" >> $Desktop/report.txt
docker logs docker-mempool_web-1 >> $Desktop/report.txt 2>&1
echo "##4##" >> $Desktop/report.txt
sudo netstat -tulnp | grep -q :8332 >> $Desktop/report.txt 2>&1 || echo "no 8332" >> $Desktop/report.txt
echo "##5##" >> $Desktop/report.txt
sudo systemctl status bitcoind.service >> $Desktop/report.txt 2>&1
echo "##6##" >> $Desktop/report.txt
docker network ps >> $Desktop/report.txt 2>&1
echo "##7##" >> $Desktop/report.txt
cat $hp/mempool/docker/docker-compose.yml >> $Desktop/report.txt 2>&1
echo "##8##" >> $Desktop/report.txt
cat $HOME/.bitcoin/bitcoin.conf >> $Desktop/report.txt 2>&1
echo "##9##" >> $Desktop/report.txt
bitcoin-cli getblockchaininfo >> $Desktop/report.txt 2>&1
echo "##10##" >> $Desktop/report.txt
bitcoin-cli getmempoolinfo >> $Desktop/report.txt 2>&1
echo "##11##" >> $Desktop/report.txt
bitcoin-cli version >> $Desktop/report.txt 2>&1
echo "##12##" >> $Desktop/report.txt
curl -s ifconfig.me >> $Desktop/report.txt 2>&1
echo "" >> $Desktop/report.txt
echo "##13##" >> $Desktop/report.txt
ip a >> $Desktop/report.txt 2>&1
echo "##14##" >> $Desktop/report.txt
echo "UFW... $(sudo ufw status)" >> $Desktop/report.txt
echo "##15##" >> $Desktop/report.txt
announce "Report saved to Desktop/report.txt please send to Parman"
fi

}