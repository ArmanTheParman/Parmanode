function install_parmawallet_dependencies {

if [[ $OS == Linux ]] ; then
sudo apt-get install -y libgmp-dev python3 python3-dev python3-pip openssl python3-bitcoinlib python3-base58 python3-tk build-essential libssl-dev locales 
elif [[ $OS == Mac ]]; then
brew install gmp
fi

#mac and linux..
while true ; do
if ! pip3 list | grep bech32 ; then

    pip3 install bech32 --break-system-packages

    if ! pip3 list | grep bech32 ; then
    pip3 install bech32 
    break
    else break
    fi
fi

while true ; do
if ! pip3 list | grep base58 ; then

    pip3 install base 58 --break-system-packages

    if ! pip3 list | grep base58 ; then
    pip3 install base58 
    break
    else break
    fi
fi

while true ; do
if ! pip3 list | grep bip-utils ; then

    pip3 install bip-utils --break-system-packages

    if ! pip3 list | grep bip-utils ; then
    pip3 install bip-utils 
    break
    else break
    fi
fi
while true ; do
if ! pip3 list | grep bitcoinlib ; then

    pip3 install bitcoinlib --break-system-packages

    if ! pip3 list | grep bitcoinlib ; then
    pip3 install bitcoinlib 
    break
    else break
    fi
fi
while true ; do
if ! pip3 list | grep cryptography ; then

    pip3 install cryptography --break-system-packages

    if ! pip3 list | grep cryptography ; then
    pip3 install cryptography 
    break
    else break
    fi
fi
while true ; do
if ! pip3 list | grep pycryptodome ; then

    pip3 install pycryptodome --break-system-packages

    if ! pip3 list | grep pycryptodome ; then
    pip3 install pycryptodome 
    break
    else break
    fi
fi
while true ; do
if ! pip3 list | grep gmp ; then

    pip3 install gmp --break-system-packages

    if ! pip3 list | grep gmp ; then
    pip3 install gmp 
    break
    else break
    fi
fi
while true ; do
if ! pip3 list | grep fastecdsa ; then

    pip3 install fastecdsa --break-system-packages

    if ! pip3 list | grep fastecdsa ; then
    pip3 install fastecdsa 
    break
    else break
    fi
fi

}