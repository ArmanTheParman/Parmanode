function download_specter {

specter_version="2.0.1"
cd $HOME/parmanode/specter

curl -LO https://github.com/cryptoadvance/specter-desktop/releases/download/v${specter_version}/SHA256SUMS
curl -LO https://github.com/cryptoadvance/specter-desktop/releases/download/v${specter_version}/SHA256SUMS.asc

if [[ $OS == "Mac" ]] ; then
curl -LO https://github.com/cryptoadvance/specter-desktop/releases/download/v${specter_version}/Specter-v${specter_version}.dmg || return 1
fi

if [[ $OS == "Linux" ]] ; then

        if [[ $chip == "x86_64" || $chip == "amd64" ]] ; then
        curl -LO https://github.com/cryptoadvance/specter-desktop/releases/download/v${specter_version}/specter_desktop-v${specter_version}-x86_64-linux-gnu.tar.gz || return 1
        else
        set_terminal ; echo "
########################################################################################
    Unfortunately, Parmanode does not yet support Specter desktop for your computer's
    chip architecture. Aborting.
########################################################################################
        "
        enter_continue
        return 1
        fi
fi

}
