function download_sparrow {
cd $HOME/parmanode
while true ; do 
    announce "Installing Sparrow Version $sparrow_version. If you want a different
    version, try typing the value in. Othewise just hit <enter> for the default."
    jump || $enter_cont
    case $enter_cont in     "") break 
                                ;; 
                             *) export sparrow_version=$enter_cont 
                                yesorno "Do you want version $sparrow_version?" || continue 
                                break
                                ;;
    esac
done
clear

#clean up previous downloads if any
sudo rm -rf $hp/"*parrow-*" >$dn

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
