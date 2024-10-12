function install_electrum_pip {

sudo apt-get install -y python3-pyqt5 libsecp256k1-dev python3 python3-cryptography python3-setuptools python3-pip
mkdir -p $hp/electrum_pip
cd $hp/electrum_pip
curl -LO https://download.electrum.org/4.5.5/Electrum-4.5.5.tar.gz
curl -LO https://download.electrum.org/4.5.5/Electrum-4.5.5.tar.gz.asc
curl -LO https://raw.githubusercontent.com/spesmilo/electrum/master/pubkeys/ThomasV.asc 
gpg --import ThomasV.asc

if ! gpg --verify Electrum-4.5.5.tar.gz.asc 2>&1 | grep -qi good ; then
    announce "gpg verification failed"
    return 1
fi

python3 -m pip install --user Electrum-4.5.5.tar.gz || \
    python3 -m pip install --user Electrum-4.5.5.tar.gz --break-system-packages || \
    {
    echo "Something went wrong"
    enter_continue
    return 1
    }


