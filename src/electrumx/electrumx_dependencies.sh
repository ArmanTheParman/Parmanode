function electrumx_dependencies {
sudo apt-get update -y
sudo apt-get install -y librocksdb-dev python3 python3-pip python3-dev

#recommended in docs, but there's no need unless building applications...
#pip3 install aiohttp -y

# python-rocksdb installed with setup.py script (pip3 install .)

}