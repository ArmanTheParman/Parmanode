function make_parmanode_service {

if grep -q "parmanode_service=enabled" < $pc ; then return 0 ; fi

echo "[Unit]
Description=Parmanode Background Services
After=network.target

[Service]
Type=simple
ExecStart=$HOME/.parmanode/parmanode_script.sh
Restart=never
KillMode=process

[Install]
WantedBy=multi-user.target
" | sudo tee /etc/systemd/system/parmanode.service >/dev/null 2>&1

make_parmanode_script

sudo systemctl daemon-reload >/dev/null 2>&1
sudo systemctl enable parmanode.service >/dev/null 2>&1
sudo systemctl start parmanode.service >/dev/null 2>&1

parmanode_conf_add "parmanode_service=enabled"
}


function make_parmanode_script {

echo '#!/bin/bash
if ! which tor ; then
sudo apt-get install tor -y
fi
' | sudo tee $HOME/.parmanode/parmanode_script.sh >/dev/null 2>&1

cat << EOF | sudo tee -a $HOME/.parmanode/parmanode_script.sh >/dev/null 2>&1
sudo usermod -a -G debian-tor $USER >/dev/null 2>&1

if ! sudo cat /etc/tor/torrc | grep "# Additions by Parmanode..." >/dev/null 2>&1 ; then
echo "# Additions by Parmanode..." | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
fi

if sudo grep "ControlPort 9051" /etc/tor/torrc | grep -v '^#' >/dev/null 2>&1 ; then true ; else
    echo "ControlPort 9051" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

if sudo grep "CookieAuthentication 1" /etc/tor/torrc | grep -v '^#' >/dev/null 2>&1 ; then true ; else
    echo "CookieAuthentication 1" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

if sudo grep "CookieAuthFileGroupReadable 1" /etc/tor/torrc | grep -v '^#' >/dev/null 2>&1 ; then true ; else
    echo "CookieAuthFileGroupReadable 1" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

if sudo grep "DataDirectoryGroupReadable 1" /etc/tor/torrc | grep -v '^#' >/dev/null 2>&1 ; then true ; else
    echo "DataDirectoryGroupReadable 1" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi
EOF

sudo chmod +x $HOME/.parmanode/parmanode_script.sh
sudo chown $USER:$USER $HOME/.parmanode/parmanode_script.sh

return 0

}