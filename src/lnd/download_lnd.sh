function download_lnd {
if [[ $OS != "Linux" ]] ; then return 1 ; fi
mkdir $HOME/parmanode/lnd >/dev/null 2>&1
rm -rf $HOME/parmanode/lnd/*

#get signatures and SHA256 file
cd $HOME/lnd
curl -LO https://github.com/lightningnetwork/lnd/releases/download/v0.16.2-beta/manifest-v0.16.2-beta.txt 
curl -LO https://github.com/lightningnetwork/lnd/releases/download/v0.16.2-beta/manifest-roasbeef-v0.16.2-beta.sig


if [[ $chip == "x86_64" ]] ; then
curl -LO https://github.com/lightningnetwork/lnd/releases/download/v0.16.2-beta/lnd-linux-amd64-v0.16.2-beta.tar.gz
fi

if [[ $chip == "arm64" ]] ; then
curl -LO https://github.com/lightningnetwork/lnd/releases/download/v0.16.2-beta/lnd-linux-arm64-v0.16.2-beta.tar.gz 
fi

if [[ $chip == "arm64" ]] ; then
curl -LO https://github.com/lightningnetwork/lnd/releases/download/v0.16.2-beta/lnd-linux-arm64-v0.16.2-beta.tar.gz
fi

if [[ $chip == "armv6l" ]] ; then
curl -LO https://github.com/lightningnetwork/lnd/releases/download/v0.16.2-beta/lnd-linux-armv6-v0.16.2-beta.tar.gz
fi

if [[ $chip == "armv7l" ]] ; then
curl -LO https://github.com/lightningnetwork/lnd/releases/download/v0.16.2-beta/lnd-linux-armv7-v0.16.2-beta.tar.gz
fi

}
