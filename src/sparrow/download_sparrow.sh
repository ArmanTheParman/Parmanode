function download_sparrow {
cd $HOME/parmanode

if [[ $OS == "Linux" ]] ; then

    if [[ $chip == "x86_64" || $chip == "amd64" ]] ; then
    curl -LO https://github.com/sparrowwallet/sparrow/releases/download/1.7.6/sparrow-1.7.6-x86_64.tar.gz
    fi
    if [[ $chip == "aarch64" ]] ; then
    curl -LO https://github.com/sparrowwallet/sparrow/releases/download/1.7.6/sparrow-1.7.6-aarch64.tar.gz 
    fi
fi
if [[ $OS == "Mac" ]] ; then
    if [[ $chip == "aarch64" ]] ; then
    curl -LO https://github.com/sparrowwallet/sparrow/releases/download/1.7.6/Sparrow-1.7.6-aarch64.dmg
    fi
    if [[ $chip == "x86_64" ]] ; then
    curl -LO https://github.com/sparrowwallet/sparrow/releases/download/1.7.6/Sparrow-1.7.6-x86_64.dmg
    fi
fi

curl -LO https://github.com/sparrowwallet/sparrow/releases/download/1.7.6/sparrow-1.7.6-manifest.txt
curl -LO https://github.com/sparrowwallet/sparrow/releases/download/1.7.6/sparrow-1.7.6-manifest.txt.asc
}