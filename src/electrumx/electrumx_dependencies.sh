function electrumx_dependencies {
update_computer silent || paus
sudo apt-get remove -y libdpkg-perl #my machine had a newer version, preventing build-essential to be installed
sudo apt-get install -y --fix-broken --no-install-recommends gcc g++ fakeroot python3 python3-pip python3-dev \
build-essential librocksdb-dev libsnappy-dev zlib1g-dev libbz2-dev libgflags-dev liblz4-dev libzstd-dev \
rocksdb-tools librocksdb-6.11
sudo python3 -m pip install --upgrade pip 

#virtual env install
{ virtualenv parmanenv
source parmanenv/bin/activate
cd $hp/electrumx
pip install plyvel
python -c 'import plyvel' || { announce "plyvel failed. Aborting." ; return 1 ; } ; } &&
debug "virtual environment set? ... $VIRTUAL_ENV"
deactivate #exits virtual env
debug "after deactivate command"


#recommended in docs, but there's no need unless building applications...
#pip3 install aiohttp -y

# python-rocksdb installed with setup.py script (pip3 install .)

}

function compile_rocksdb {
cd $hp
git clone --depth 1 https://github.com/facebook/rocksdb.git && cd rocksdb
mkdir build && cd build
cmake ..
make
sudo make install INSTALL_PATH=/usr
}