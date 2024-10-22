function download_sparrow {
cd $HOME/parmanode

choose_sparrow_version

#clean up previous downloads if any
sudo rm -rf $hp/"*parrow-1."*

if [[ $OS == "Linux" ]] ; then

    if [[ $chip == "x86_64" || $chip == "amd64" ]] ; then
    curl -LO https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/sparrow-${sparrow_version}-x86_64.tar.gz
    fi
    if [[ $chip == "aarch64" ]] ; then
    curl -LO https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/sparrow-${sparrow_version}-aarch64.tar.gz 
    fi
fi

if [[ $OS == "Mac" ]] ; then
    if [[ $chip == "aarch64" || $(uname -m) == arm64 || $(uname -m) == ARM64 ]] ; then
    curl -LO https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/Sparrow-${sparrow_version}-aarch64.dmg
    fi
    if [[ $chip == "x86_64" ]] ; then
    curl -LO https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/Sparrow-${sparrow_version}-x86_64.dmg
    fi
fi

curl -LO https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/sparrow-${sparrow_version}-manifest.txt
curl -LO https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/sparrow-${sparrow_version}-manifest.txt.asc
}

function choose_sparrow_version {
set_terminal ; echo -e "
########################################################################################

    If you prefer the older sparrow version 1.9.0, then type 'old' and <enter>.

    Otherwise hit <enter> alone to get version 2.0.0

########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
old)
export version="1.9.0"
*)
export version="2.0.0"
;;
esac
return 0
}