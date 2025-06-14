function make_parmadesk_service {
    return 0
cat << EOF | tee $dp/scripts/parmadesk.sh >$dn 2>&1
#!/bin/bash
for file in ~/.vnc/*log ; do
        > $file
done
EOF
sudo chmod +x $dp/scripts/parmadesk.sh

cat << EOF | sudo tee /etc/systemd/system/parmadesk.service >$dn 2>&1
[Unit]
Description=ParmaDesk Service: A 24 hour loop to keep log files small

[Service]

ExecStart=$dp/scripts/parmadesk.sh
Restart=always
RestartSec=84600

User=$(whoami)
Group=$(whoami)

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload 2>$dn
#sudo systemctl enable parmadesk.service 2>$dn
#sudo systemctl start parmadesk.service >$dn
}
