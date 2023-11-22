function download_sparrow {
cd $HOME/parmanode

while true ; do
set_terminal
echo -e "
########################################################################################
    
    Parmanode will download$cyan Sparrow Version 1.7.8$orange because it has been tested and 
    works great with Parmanode.

    Do you want to use a newer version that hasn't yet been tested? (Will be one day)
$green
                 d)       Default version 1.7.8 (recommended)
$red
                 yolo)    v 1.8.0, let's see what happens (reckless)
$orange
########################################################################################                
"
choose "xpmq" ; read choice
case $choice in
d) 
sparrow_version="1.7.8" ; break ;;
yolo)
sparrow_version="1.8.0" ; break ;;
*)
invalid ;;
esac
done
clear

#clean up previous downloads if any
rm -rf $hp/"*parrow-1."*

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