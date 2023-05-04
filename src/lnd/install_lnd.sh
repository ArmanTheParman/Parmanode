function install_lnd {
download_lnd

}

function download_lnd {

cd $HOME/parmanode
git clone http://github.com/lightningnetwork/lnd.git
cd $HOME/parmanode/lnd

}