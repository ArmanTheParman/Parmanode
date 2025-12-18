function make_btcpay_service_file {

echo "#!/bin/bash

docker start btcpay || sleep 1
docker start btcpay || exit 1

docker exec -d -u root btcpay /bin/bash -c \"service postgresql start\" || { sleep 1 && \\
       docker exec -d -u root btcpay /bin/bash -c \"service postgresql start\" ; } || exit 1 
 

docker exec -d -u parman btcpay /bin/bash -c \"cd /home/parman/parmanode/NBXplorer ; ./run.sh >/home/parman/.nbxplorer/nbxplorer.log\" 

docker exec -d -u parman btcpay /bin/bash -c \\
\"/usr/bin/dotnet run --no-launch-profile --no-build -c Release -p \\\"\\\\
/home/parman/parmanode/btcpayserver/BTCPayServer/BTCPayServer.csproj\\\" -- \$@ >\$HOME/.btcpayserver/btcpay.log\"

exit 0" | tee $HOME/parmanode/startup_scripts/btcpay_startup.sh >$dn 2>&1

chmod +x $HOME/parmanode/startup_scripts/btcpay_startup.sh >$dn 2>&1

if [[ $1 == "make_script_only" ]] ; then return 0 ; fi
file=$(mktemp)
echo "[Unit]
Description=Parmanode Start Up BTCPay 
After=network.target bitcoind.service

[Service]

ExecStart=$HOME/parmanode/startup_scripts/btcpay_startup.sh

User=$(whoami)
Group=$(whoami)

Restart=on-failure
RestartSec=10
[Install]
WantedBy=multi-user.target" | tee "$file" >$dn 2>&1

if [[ $1 == "setup" ]] ; then
    sudo chown root:root "$file" 
    sudo chmod 655 "$file"
    sudo mv "$file" /usr/local/parmanode/service/btcpay.service
    return 0
elif [[ $parmaview == 1 ]] ; then
    sudo /usr/local/parmanode/p4run "move_btcpay_service_file"
else
    sudo mv "$file" /etc/systemd/system/btcpay.service 
fi




sudo systemctl stop btcpay.service 2>$dn
sudo systemctl disable btcpay.service 2>$dn
sudo systemctl daemon-reload 2>$dn
sudo systemctl enable btcpay.service 2>$dn
sudo systemctl start btcpay.service 2>$dn

}