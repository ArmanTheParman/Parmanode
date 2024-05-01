function PW_dependencies {

if [[ $1 != skip ]] ; then
sudo apt-get install libgmp-dev #?cargo, not sure
sudo pip3 install bitcoinlib base48 bech32
fi

opensslconf="$(openssl info -configdir)/openssl.cnf"

if [[ -e ${opensslconf}_backuip ]] ; then
cp ${opensslconf}_backup $opensslconf  #restors original
fi

sudo cp $opensslconf ${opensslconf}_backup #backs up original

swap_string "$opensslconf" "# activate = 1" "activate = 1

[legacy sect]
activate = 1"
}