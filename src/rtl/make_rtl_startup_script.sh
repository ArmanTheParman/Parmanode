function make_rtl_startup_script {

echo "#!/bin/bash
docker start rtl
docker exec -d rtl sh -c "cd /home/parman/RTL && node rtl" && exit 0 || sleep 1
docker exec -d rtl sh -c "cd /home/parman/RTL && node rtl" && exit 0 || sleep 1
docker exec -d rtl sh -c "cd /home/parman/RTL && node rtl" && exit 0 || sleep 1
docker exec -d rtl sh -c "cd /home/parman/RTL && node rtl" && exit 0 || sleep 1
docker exec -d rtl sh -c "cd /home/parman/RTL && node rtl" && exit 0 || sleep 1
docker exec -d rtl sh -c "cd /home/parman/RTL && node rtl" && exit 0 || echo "failed to start rtl"
sleep 2
exit 1" > $HOME/parmanode/startup_scripts/rtl_startup.sh 2>&1
sudo chmod +x $HOME/parmanode/startup_scripts/rtl_startup.sh >/dev/null 2>&1



echo "[Unit]
Description=Parmanode Start Up RTL
After=network.target bitcoind.service

[Service]

ExecStart=$HOME/parmanode/startup_scripts/rtl_startup.sh

User=$(whoami)
Group=$(whoami)

Restart=on-failure
RestartSec=10
[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/rtl.service 2>/dev/null

sudo systemctl stop rtl.service 2>/dev/null
sudo systemctl disable rtl.service 2>/dev/null
sudo systemctl daemon-reload 2>/dev/null
sudo systemctl enable rtl.service 2>/dev/null
sudo systemctl start rtl.service 2>/dev/null
}