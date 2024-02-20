function electrum_dependencies {

if [[ $OS == Linux ]] ; then
sudo apt-get install python3-pyqt5 libsecp256k1-dev python3-cryptography -y
fi

if [[ $OS == Mac ]] ; then
pip3 install pyqt5 cryptography
brew_check || return 1
brew install autoconf automake libtool
cd $hp/electrum
git clone https://github.com/bitcoin-core/secp256k1.git
cd secp256k1
./autogen.sh
./configure
make
sudo make install
fi

}