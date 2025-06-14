function make_parmadesk_service {

cat << EOF | tee $dp/scripts/parmadesk.sh
#!/bin/bash
trap "exit 0" SIGTERM
while true ; do
    for file in ~/.vnc/*log ; do
        > $file
    done
sleep 86400
done
EOF
sudo chmod +x $dp/scripts/parmadek.sh

echo "[Unit]
Description=ParmaDesk Service

[Service]
Type=simple

ExecStart=$dp/scripts/parmadesk.sh
ExecStop=/bin/kill -s SIGTERM \$MAINPID
KillMode=process

User=$(whoami)
Group=$(whoami)

Restart=on-failure
RestartSec=3000
[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/parmadesk.service >$dn 2>&1

sudo systemctl daemon-reload 2>$dn
sudo systemctl enable --now parmadesk.service 2>$dn
}
