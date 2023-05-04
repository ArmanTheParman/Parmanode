function install_lnd {
download_lnd

}

function download_lnd {


if [[ $OS == "Linux" ]] ; then
if [[ $chip == "x86_64" ]] ; then
cd $HOME/parmanode

https://github.com/lightningnetwork/lnd/releases/download/v0.16.2-beta/lnd-linux-amd64-v0.16.2-beta.tar.gz
fi
}
if [[ $chip == "arm64" ]] ; then
