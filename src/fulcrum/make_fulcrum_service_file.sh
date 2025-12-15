function make_fulcrum_service_file {

if [[ ! -e $dp/scripts/mount_check.sh ]] ; then make_mount_check_script ; fi
file=$(mktemp)
echo "[Unit]
Description=Fulcrum_daemon
After=network-online.target
Wants=network-online.target

[Service]
ExecStartPre=$HOME/.parmanode/scripts/mount_check.sh
ExecStart=/usr/local/bin/Fulcrum $HOME/.fulcrum/fulcrum.conf 
StandardOutput=append:$HOME/.fulcrum/fulcrum.log
StandardError=inherit

TimeoutStopSec=90s
KillSignal=SIGTERM

User=$(whoami)
Group=$(id -ng)

[Install]
WantedBy=multi-user.target
" | tee "$file" >$dn 2>&1

if [[ $1 == "setup" ]] ; then
    sudo chown root:root "$file"
    sudo chmod 644 "$file"
    sudo mv "$file" /usr/local/parmanode/fulcrum.service
elif [[ $parmaview == 1 ]] ; then
    sudo mv /usr/local/parmanode/fulcrum.service /etc/systemd/system/fulcrum.service
else
    sudo mv "$file" /etc/systemd/system/fulcrum.service
fi    

#tee used instead of echo because redirection operator after sudo echo loses sudo privilages

sudo systemctl daemon-reload 
sudo systemctl disable fulcrum.service >$dn 2>&1
sudo systemctl enable fulcrum.service >$dn 2>&1

return 0
}

