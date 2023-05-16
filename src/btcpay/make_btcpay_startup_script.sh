function make_btcpay_startup_script {

echo "#!/bin/bash

docker start btcpay || sleep 1
docker start btcpay || exit 1

docker exec -d -u root btcpay /bin/bash -c \"service postgresql start\" || { sleep 1 && \\
       docker exec -d -u root btcpay /bin/bash -c \"service postgresql start\" ; } || exit 1 
 

docker exec -d -u parman btcpay /bin/bash -c \"cd /home/parman/parmanode/NBXplorer ; ./run.sh >/home/parman/.nbxplorer/nbxplorer.log\" 

docker exec -d -u parman btcpay /bin/bash -c \\
\"/usr/bin/dotnet run --no-launch-profile --no-build -c Release -p \\\"\\\\
/home/parman/parmanode/btcpayserver/BTCPayServer/BTCPayServer.csproj\\\" -- \$@\"

exit 0" > /tmp/test.sh 


> $HOME/parmanode/startup_scripts/btcpay_startup.sh 2>&1

sudo chmod +x $HOME/parmanode/startup_scripts/btcpay_startup.sh >/dev/null 2>&1



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
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/btcpay.service 2>/dev/null



sudo systemctl stop btcpay.service 2>/dev/null
sudo systemctl disable btcpay.service 2>/dev/null
sudo systemctl daemon-reload 2>/dev/null
sudo systemctl enable btcpay.service 2>/dev/null
sudo systemctl start btcpay.service 2>/dev/null

}