function extract_electrum {

cd $HOME/parmanode/electrum

tar -xvf Ele*.tar.gz
mv ./Ele*/* ./
find . -type d -name 'Electrum-*' -exec rm -rf {} + # removes all directories that start with Electrum-

}