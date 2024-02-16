function electrumx_dependencies {
update_computer silent
sudo apt-get remove -y libdpkg-perl #my machine had a newer version, preventing build-essential to be installed
sudo apt-get install -y --fix-broken --no-install-recommends fakeroot python3 python3-pip python3-dev \
build-essential librocksdb-dev libsnappy-dev zlib1g-dev libbz2-dev libgflags-dev liblz4-dev libzstd-dev \
rocksdb-tools

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