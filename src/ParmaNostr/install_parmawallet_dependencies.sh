function install_parmawallet_dependencies {
set_terminal
echo -e "${green}Checking for and installing dependencies...$orange"

if [[ $OS == Linux ]] ; then
sudo apt-get install -y libgmp-dev python3 python3-dev python3-pip openssl python3-bitcoinlib python3-base58 python3-tk build-essential libssl-dev locales 
elif [[ $OS == Mac ]]; then
brew install gmp
export CFLAGS="-I$(brew --prefix gmp)/include"
export LDFLAGS="-L$(brew --prefix gmp)/lib"
fi

#mac and linux..

for i in "bech32" "base58" "bip-utils" "bitcoinlib" "cryptography" "pycryptodome" "gmp" \
         "fastecdsa" "websockets" "websocket-client" ; do
if ! pip3 list | grep $i ; then

    pip3 install $i --break-system-packages

    if ! pip3 list | grep $i ; then
    pip3 install $i 
    else debug "no $i" 
    fi
fi
done

}