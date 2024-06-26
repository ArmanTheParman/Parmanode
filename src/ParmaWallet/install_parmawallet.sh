function install_parmawallet {

if [[ $OS == Linux ]] ; then
sudo apt-get install -y libgmp-dev python3 python3-dev python3-pip openssl python3-bitcoinlib python3-base58 python3-tk build-essential libssl-dev locales 
fi

#mac and linux..

pip3 install bech32 --break-system-packages
pip3 install base58 --break-system-packages
pip3 install bip-utils --break-system-packages
pip3 install bitcoinlib --break-system-packages
pip3 install cryptography --break-system-packages
pip3 install pycryptodome --break-system-packages

pip3 install bech32 
pip3 install base58 
pip3 install bip_utils
pip3 install bitcoinlib 
pip3 install cryptography
pip3 install pycryptodome 


}