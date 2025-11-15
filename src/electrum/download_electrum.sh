function download_electrum {

cd $HOME/parmanode/electrum

choose_electrum_version

if [[ $computer_type == "LinuxPC" ]] ; then
    curl -LO https://download.electrum.org/$electrum_version/electrum-${electrum_version}-x86_64.AppImage && \
    curl -LO https://download.electrum.org/${electrum_version}/electrum-${electrum_version}-x86_64.AppImage.asc && \
    curl -LO https://raw.githubusercontent.com/spesmilo/electrum/master/pubkeys/ThomasV.asc 
    return 0
    fi

if [[ $computer_type == "Pi" ]] ; then
    curl -LO https://download.electrum.org/${electrum_version}/Electrum-${electrum_version}.tar.gz
    curl -LO https://download.electrum.org/${electrum_version}/Electrum-${electrum_version}.tar.gz.asc
    curl -LO https://raw.githubusercontent.com/spesmilo/electrum/master/pubkeys/ThomasV.asc 
    return 0
    fi

if [[ $OS == Mac ]] ; then
    curl -LO https://download.electrum.org/${electrum_version}/electrum-${electrum_version}.dmg && \
    curl -LO https://download.electrum.org/${electrum_version}/electrum-${electrum_version}.dmg.asc && \
    curl -LO https://raw.githubusercontent.com/spesmilo/electrum/master/pubkeys/ThomasV.asc 
fi


}
