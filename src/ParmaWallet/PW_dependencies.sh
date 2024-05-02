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


function fix_openssl_ripemd160 {
opensslconf="$(openssl info -configdir)/openssl.cnf"
if [[ -e ${opensslconf}_backup ]] ; then
sudo cp ${opensslconf}_backup $opensslconf  #restores original
fi
sudo cp $opensslconf ${opensslconf}_backup #backs up original
swap_string "$opensslconf" "# activate = 1" "activate = 1"
echo "[legacy sect]
activate = 1" | sudo tee -a $opensslconf >/dev/null
debug "pause d"
}