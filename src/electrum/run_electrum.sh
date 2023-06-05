function run_electrum {

#delete certificates, cach, and sockets - more likely to connect to server.
cd $HOME/.electrum && rm -rf certs cache daemon*

nohup $HOME/parmanode/electrum/electrum*AppImage >/dev/null 2>&1 &
}