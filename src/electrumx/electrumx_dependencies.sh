function electrumx_dependencies {
if ! which python3 >/dev/null ; then sudo apt-get update -y && sudo apt-get install python3 python3-pip
fi
if ! which pip3 ; then sudo apt-get update -y && sudo apt-get install python3-pip
fi
#recommended in docs, but there's no need unless building applications...
#pip3 install aiohttp -y

# python-rocksdb installed with setup.py script (pip3 install .)

}