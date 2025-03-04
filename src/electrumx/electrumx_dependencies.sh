function electrumx_dependencies {
yesorno "OK to update the OS?" && update_computer 
set_terminal
rm $dp/electrumx.log

echo -e "${green}Installing dependencies...$orange"
sudo apt-get remove -y libdpkg-perl #my machine had a newer version, preventing build-essential to be installed
sudo apt-get install -y --fix-broken --no-install-recommends gcc g++ fakeroot python3 python3-pip python3-dev | tee -a $dp/electrumx.log
sudo apt-get install -y build-essential librocksdb-dev libleveldb-dev libsnappy-dev zlib1g-dev libbz2-dev libgflags-dev liblz4-dev libzstd-dev | tee -a $dp/electrumx.log 
sudo apt-get install -y rocksdb-tools librocksdb6.11 | tee -a $dp/electrumx.log
sudo apt-get install -y python3-venv python3-dev python3-pip virtualenv libsnappy-dev libleveldb-dev |  tee -a $dp/electrumx.log

sudo python3 -m pip install --upgrade pip | tee -a $dp/electrumx.log
sudo pip3 install virtualenv | tee -a $dp/electrumx.log
debug "virtual env version... $(virtualenv --version)" 
#virtual env install

{
    python3 -m venv parmanenv
    source parmanenv/bin/activate
    debug "virtual environment set? ... $VIRTUAL_ENV"

    [[ -d $hp/electrumx ]] || mkdir -p $hp/electrumx 
    cd "$hp/electrumx"
    
    pip install plyvel | tee -a "$dp/electrumx.log"

    # Correct way to check if plyvel is installed
    python3 -c 'import plyvel' || {
        enter_continue "plyvel failed. Aborting."
        exit 1
    }

    deactivate  # Exit virtual environment
    debug "after deactivate command"
}
}

function compile_rocksdb {
cd $hp
git clone --depth 1 https://github.com/facebook/rocksdb.git && cd rocksdb
mkdir build && cd build
cmake ..
make
sudo make install INSTALL_PATH=/usr
}