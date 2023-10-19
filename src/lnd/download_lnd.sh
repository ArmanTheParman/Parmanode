function download_lnd {
if [[ $OS != "Linux" ]] ; then return 1 ; fi

rm -rf $HOME/parmanode/lnd/*

lndversion="v0.17.0-beta"

#get signatures and SHA256 file
cd $HOME/parmanode/lnd
curl -LO https://github.com/lightningnetwork/lnd/releases/download/v0.16.2-beta/manifest-$lndversion.txt 
curl -LO https://github.com/lightningnetwork/lnd/releases/download/v0.16.2-beta/manifest-roasbeef-$lndversion.sig


if [[ $chip == "x86_64" ]] ; then
curl -LO https://github.com/lightningnetwork/lnd/releases/download/v0.16.2-beta/lnd-linux-amd64-$lndversion.tar.gz
fi

if [[ $chip == "arm64" || $chip == "aarch64" ]] ; then
curl -LO https://github.com/lightningnetwork/lnd/releases/download/v0.16.2-beta/lnd-linux-arm64-$lndversion.tar.gz 
fi

if [[ $chip == "armv6l" ]] ; then
curl -LO https://github.com/lightningnetwork/lnd/releases/download/v0.16.2-beta/lnd-linux-armv6-$lndversion.tar.gz
fi

if [[ $chip == "armv7l" ]] ; then
curl -LO https://github.com/lightningnetwork/lnd/releases/download/v0.16.2-beta/lnd-linux-armv7-$lndversion.tar.gz
fi
}
