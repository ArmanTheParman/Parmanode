function PW_dependencies {

if [[ $1 != skip ]] ; then
sudo apt-get install libgmp-dev python3 pip -y #?cargo, not sure
sudo apt-get install python3-bitcoinlib python3-base58 -y
#depending on the system, works with or without --break-system-packages. Try both
sudo pip3 install pycryptodome bech32 cryptography bip_utils bitcoinlib base58 --break-system-packages
sudo pip3 install pycryptodome bech32 cryptography bip_utils bitcoinlib base58 
fi

fix_openssl_ripemd160
}


