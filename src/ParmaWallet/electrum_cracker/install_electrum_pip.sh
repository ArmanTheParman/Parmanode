function install_electrum_pip {
clear
echo "Installing dependencies...
"
#necessary programs
sudo apt-get install -y python3-pyqt5 libsecp256k1-dev python3 python3-cryptography python3-setuptools python3-pip
#working directory
mkdir -p $hp/electrum_pip
cd $hp/electrum_pip
#need electrum python scripts - download and verify.
curl -LO https://download.electrum.org/4.5.5/Electrum-4.5.5.tar.gz
curl -LO https://download.electrum.org/4.5.5/Electrum-4.5.5.tar.gz.asc
curl -LO https://raw.githubusercontent.com/spesmilo/electrum/master/pubkeys/ThomasV.asc 
gpg --import ThomasV.asc

if ! gpg --verify Electrum-4.5.5.tar.gz.asc 2>&1 | grep -qi good ; then
    announce "gpg verification failed"
    return 1
fi
#install electrum into pip, so it's available to python imports
#sometimes --break-system-packages is needed, sometime starting with that fails, so try both.
python3 -m pip install --user Electrum-4.5.5.tar.gz || \
    python3 -m pip install --user Electrum-4.5.5.tar.gz --break-system-packages || \
    {
    echo "Something went wrong. Hit <enter> to exit>"
    read
    return 1
    }


