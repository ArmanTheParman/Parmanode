function electrumx_dependencis {
if ! which python3 >/dev/null ; then sudo apt-get update -y && sudo apt-get install python3 
fi

#recommended in docs, but there's no need unless building applications...
#pip3 install aiohttp -y

# python-rocksdb installed with setup.py script (pip3 install .)

}