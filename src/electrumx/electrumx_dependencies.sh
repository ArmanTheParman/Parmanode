function electrumx_dependencies {
update_computer silent
sudo apt-get install -y fakeroot python3 python3-pip python3-dev build-essential \
libsnappy-dev zlib1g-dev libbz2-dev libgflags-dev liblz4-dev libzstd-dev librocksdb-dev --no-install-recommends

#recommended in docs, but there's no need unless building applications...
#pip3 install aiohttp -y

# python-rocksdb installed with setup.py script (pip3 install .)

}