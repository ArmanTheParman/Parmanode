function make_parmadesk_service {
cat << EOF | tee $dp/scripts/parmadesk.sh >$dn 2>&1
#!/bin/bash
trap "exit 0" SIGTERM
while true ; do
    for file in ~/.vnc/*log ; do
        > $file
    done
sleep 86400
done
EOF
sudo chmod +x $dp/scripts/parmadesk.sh

cat << EOF | sudo tee /etc/systemd/system/parmadesk.service >$dn 2>&1
[Unit]
Description=ParmaDesk Service: A 24 hour loop to keep log files small

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
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload 2>$dn
sudo systemctl enable parmadesk.service 2>$dn
sudo systemctl start parmadesk.service >$dn
}
