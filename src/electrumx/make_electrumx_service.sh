function make_electrumx_service {

file=$(mktemp)

cat << EOF | tee "$file" >$dn 2>&1
[Unit]
Description=Electrumx
After=network.target

[Service]
EnvironmentFile=$hp/electrumx/electrumx.conf
ExecStart=$HOME/.local/bin/electrumx_server
ExecStop=$HOME/.local/bin/electrumx_rpc -p 8000 stop 
User=$USER
LimitNOFILE=8192
TimeoutStopSec=30min

[Install]
WantedBy=multi-user.target
EOF

if [[ $1 == "setup" ]] ; then
    sudo chown root:root "$file"
    sudo chmod 655 "$file"
    sudo mv "$file" /usr/local/parmanode/service/electrumx.service
    return 0
elif [[ $parmaview == 1 ]] ; then
    sudo mv /usr/local/parmanode/service/electrumx.service /etc/systemd/system/electrumx.service
else
    sudo mv "$file" /etc/systemd/system/electrumx.service >$dn 2>&1
fi

sudo systemctl daemon-reload >$dn 2>&1
sudo systemctl enable electrumx.service >$dn 2>&1

}