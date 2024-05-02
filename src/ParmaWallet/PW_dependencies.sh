function PW_dependencies {
debug "pause before skip"
if [[ $1 != skip ]] ; then
sudo apt-get install libgmp-dev python3 pip #?cargo, not sure
sudo apt-get install python3-bitcoinlib python3-base58
#depending on the system, works with or without --break-system-packages. Try both
sudo pip3 install pycryptodome bech32 cryptography bip_utils bitcoinlib base58 --break-system-packages
sudo pip3 install pycryptodome bech32 cryptography bip_utils bitcoinlib base58 
fi
debug "pause after skip"
opensslconf="$(openssl info -configdir)/openssl.cnf"
debug "pause a"
if [[ -e ${opensslconf}_backup ]] ; then
sudo cp ${opensslconf}_backup $opensslconf  #restores original
fi
debug "pause b"
sudo cp $opensslconf ${opensslconf}_backup #backs up original
debug "pause c"

swap_string "$opensslconf" "# activate = 1" "activate = 1"

echo "[legacy sect]
activate = 1" | sudo tee -a $opensslconf >/dev/null
debug "pause d"
}
