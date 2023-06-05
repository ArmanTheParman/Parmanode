function run_electrum {

#delete certificates, cach, and sockets - more likely to connect to server.
cd $HOME/.electrum && rm -rf certs cache daemon*

please_wait

nohup $HOME/parmanode/electrum/electrum*AppImage >/dev/null 2>&1 &
}