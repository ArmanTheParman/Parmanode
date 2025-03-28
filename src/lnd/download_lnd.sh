function download_lnd {
debug "in download_lnd. version... $lndversion"
if [[ $OS != "Linux" ]] ; then return 1 ; fi
sudo rm -rf $HOME/parmanode/lnd/*


#get signatures and SHA256 file
cd $HOME/parmanode/lnd
curl -LO https://github.com/lightningnetwork/lnd/releases/download/${lndversion}/manifest-${lndversion}.txt
curl -LO https://github.com/lightningnetwork/lnd/releases/download/${lndversion}/manifest-roasbeef-${lndversion}.sig


if [[ $chip == "x86_64" ]] ; then
curl -LO https://github.com/lightningnetwork/lnd/releases/download/${lndversion}/lnd-linux-amd64-${lndversion}.tar.gz
fi

if [[ $chip == "arm64" || $chip == "aarch64" ]] ; then
curl -LO https://github.com/lightningnetwork/lnd/releases/download/${lndversion}/lnd-linux-arm64-${lndversion}.tar.gz 
fi

if [[ $chip == "armv6l" ]] ; then
curl -LO https://github.com/lightningnetwork/lnd/releases/download/${lndversion}/lnd-linux-armv6-${lndversion}.tar.gz
fi

if [[ $chip == "armv7l" ]] ; then
curl -LO https://github.com/lightningnetwork/lnd/releases/download/${lndversion}/lnd-linux-armv7-${lndversion}.tar.gz
fi
debug "download done"
}
