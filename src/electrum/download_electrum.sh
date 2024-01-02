function download_electrum {

cd $HOME/parmanode/electrum

if [[ $computer_type == "LinuxPC" ]] ; then
    curl -LO https://download.electrum.org/4.4.6/electrum-4.4.6-x86_64.AppImage && \
    curl -LO https://download.electrum.org/4.4.6/electrum-4.4.6-x86_64.AppImage.asc && \
    curl -LO https://raw.githubusercontent.com/spesmilo/electrum/master/pubkeys/ThomasV.asc 
    fi

if [[ $computer_type == "Pi" ]] ; then
    curl -LO https://download.electrum.org/4.4.6/Electrum-4.4.6.tar.gz
    curl -LO https://download.electrum.org/4.4.6/Electrum-4.4.6.tar.gz.asc
    curl -LO https://raw.githubusercontent.com/spesmilo/electrum/master/pubkeys/ThomasV.asc 
    fi


if [[ $OS == "Mac" ]] ; then
curl -LO https://download.electrum.org/4.4.6/electrum-4.4.6.dmg && \
curl -LO https://download.electrum.org/4.4.6/electrum-4.4.6.dmg.asc && \
curl -LO https://raw.githubusercontent.com/spesmilo/electrum/master/pubkeys/ThomasV.asc 
fi

}