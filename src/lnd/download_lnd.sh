function download_lnd {
if [[ $OS != "Linux" ]] ; then return 1 ; fi


if [[ $chip == "x86_64" ]] ; then
cd $HOME/parmanode
curl -Lo https://github.com/lightningnetwork/lnd/releases/download/v0.16.2-beta/lnd-linux-amd64-v0.16.2-beta.tar.gz
fi

if [[ $chip == "arm64" ]] ; then
cd $HOME/parmanode
curl -Lo https://github.com/lightningnetwork/lnd/releases/download/v0.16.2-beta/lnd-linux-arm64-v0.16.2-beta.tar.gz 
fi

if [[ $chip == "arm64" ]] ; then
cd $HOME/parmanode
curl -Lo https://github.com/lightningnetwork/lnd/releases/download/v0.16.2-beta/lnd-linux-arm64-v0.16.2-beta.tar.gz
fi

if [[ $chip == "armv6l" ]] ; then
cd $HOME/parmanode
curl -Lo https://github.com/lightningnetwork/lnd/releases/download/v0.16.2-beta/lnd-linux-armv6-v0.16.2-beta.tar.gz
fi

if [[ $chip == "armv7l" ]] ; then
cd $HOME/parmanode
curl -Lo https://github.com/lightningnetwork/lnd/releases/download/v0.16.2-beta/lnd-linux-armv7-v0.16.2-beta.tar.gz
fi

}
