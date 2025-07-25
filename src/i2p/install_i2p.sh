function install_i2p {
if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

if [[ $computer_type == "Pi" ]] ; then 
  clear ; install_i2p_for_Pi || return 1 ;
  return 0 ;
fi

set_terminal
sudo apt-get install -y default-jre 
mkdir -p $hp/i2p ; cd $hp/i2p
installed_config_remove "i2p-start"
curl -LO https://parmanode.com/i2pinstall_2.8.2.jar
shasum -a 256 ./i2pinstall_2.8.2.jar | grep -q "cd606827a9bca363bd6b3c89664772ec211d276cce3148f207643cc5e5949b8a" ||  { sww "shasum failed." ; return 1 ; }
java -jar i2pinstall_2.8.2.jar
make_i2p_service

installed_config_add "i2p-end"
success "I2P installed"
}


function install_i2p_for_Pi {

sudo apt-get install -y apt-transport-https lsb-release

if grep -qi "buster" /etc/os-release; then
echo "deb https://deb.i2p.net/ $(dpkg --status tzdata | grep Provides | cut -f2 -d'-') main" \
  | sudo tee /etc/apt/sources.list.d/i2p.list

#symlink necessary. Source downloaded later
sudo ln -sf /usr/share/keyrings/i2p-archive-keyring.gpg /etc/apt/trusted.gpg.d/i2p-archive-keyring.gpg

else
echo "deb [signed-by=/usr/share/keyrings/i2p-archive-keyring.gpg] https://deb.i2p.net/ $(lsb_release -sc) main" \
  | sudo tee /etc/apt/sources.list.d/i2p.list
fi

cd /$tmp
curl -o i2p-archive-keyring.gpg https://geti2p.net/_static/i2p-archive-keyring.gpg
gpg --import i2p-archive-keyring.gpg
gpg --fingerprint killyourtv@i2pmail.org | grep -q "7840 E761 0F28 B904 7535  49D7 67EC E560 5BCF 1346" || { 
           gpg --remove-key killyourtv@i2pmail.org 
           sww "GPG key import failed." 
           return 1 
           }
sudo cp i2p-archive-keyring.gpg /usr/share/keyrings
sudo apt-get update && export APT_UPDATE="true"
sudo apt-get install -y i2p i2p-keyring
installed_config_add "i2p-end"
installed_config_add "i2p-new4" #flag to tell  users of the old version to reinstall (if end exists and new doesn't)
success "I2P installed"
start_i2p
}


function make_i2p_service {


cat <<EOF >$dp/scripts/i2p.sh
#!/bin/bash
cd ~/i2p
./i2prouter start
sleep 5
exec java -cp "lib/*:lib/i2p.jar" net.i2p.sam.SAMBridge
EOF
sudo chmod +x $dp/scripts/i2p.sh

cat <<EOF | sudo tee /etc/systemd/system/i2p.service
[Unit]
Description=I2P Router
Wants=network.target

[Service]
WorkingDirectory=$HOME/i2p
ExecStart=$dp/scripts/i2p.sh
User=$USER
Group=$USER

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now i2p.service

}