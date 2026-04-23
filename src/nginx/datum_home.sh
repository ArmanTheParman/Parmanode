function datum_home {

if sudo test -f /etc/systemd/system/autossh_datum.service ; then
  announce "The datum service file already exists"
  return 1
fi

sudo apt-get update -y
sudo apt-get install autossh -y

while true ; do
    announce "Please enter your VPS's IP address"
    chosenIP=$enter_cont
    yesorno "Use$green $chosenIP$orange ?" || continue
    break
done

cat <<EOF | sudo tee /etc/systemd/system/autossh_datum.service >$dn 2>&1
[Unit]
After=network-online.target
Wants=network-online.target

[Service]
  User=root
  Group=root
  Environment="AUTOSSH_GATETIME=0"
  ExecStart=/usr/bin/autossh -C -M 0 -v -N -o "ServerAliveInterval=60" -R 23335:127.0.0.1:23334 root@chosenIP
  StandardOutput=journal
  Restart=always
  RestartSec=30

[Install]
  WantedBy=multi-user.target
EOF

sudo systemctl enable autossh_datum.service
sudo systemctl start autossh_datum.service
success "The autoSSH tunnel for datum has been completed."
}