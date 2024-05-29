function download_litd {
debug "in download_litd"
if [[ $OS != "Linux" ]] ; then return 1 ; fi
 
rm -rf $HOME/parmanode/litd/*


#get signatures and SHA256 file
cd $HOME/parmanode/litd
curl -LO https://github.com/lightninglabs/lightning-terminal/releases/download/${litdversion}/manifest-${litdversion}.sig
curl -LO https://github.com/lightninglabs/lightning-terminal/releases/download/${litdversion}/manifest-${litdversion}.txt


if [[ $chip == "x86_64" ]] ; then
curl -LO https://github.com/lightninglabs/lightning-terminal/releases/download/${litdversion}/lightning-terminal-linux-amd64-${litdversion}.tar.gz
fi

if [[ $chip == "arm64" || $chip == "aarch64" ]] ; then
curl -LO https://github.com/lightninglabs/lightning-terminal/releases/download/${litdversion}/lightning-terminal-linux-arm64-${litdversion}.tar.gz
fi

if [[ $chip == "armv6l" ]] ; then
curl -LO https://github.com/lightninglabs/lightning-terminal/releases/download/${litdversion}/lightning-terminal-linux-armv6-${litdversion}.tar.gz
fi

if [[ $chip == "armv7l" ]] ; then
curl -LO https://github.com/lightninglabs/lightning-terminal/releases/download/${litdversion}/lightning-terminal-linux-armv7-${litdversion}.tar.gz
fi
}
