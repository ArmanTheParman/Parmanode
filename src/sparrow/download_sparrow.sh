function download_sparrow {
cd $HOME/parmanode
while true ; do 
    announce "Installing Sparrow Version$green $sparrow_version$orange. 
    
    If you want a different version, try typing the value in. 
    Othewise just hit$cyan <enter>$orange for the default."
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

#sparrow has inconsistent filenames for various versions, so some ugly code here to work around it
if [[ $OS == "Linux" ]] ; then
    if [[ $chip == "x86_64" || $chip == "amd64" ]] ; then
        if    curl -sfI https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/sparrow-${sparrow_version}-x86_64.tar.gz ; then
              curl -LO https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/sparrow-${sparrow_version}-x86_64.tar.gz
        elif    curl -sfI https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/sparrowwallet-${sparrow_version}-x86_64.tar.gz ; then
                curl -LO https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/sparrowwallet-${sparrow_version}-x86_64.tar.gz
        elif    curl -sfI https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/Sparrow-${sparrow_version}-x86_64.tar.gz ; then
              curl -LO https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/Sparrow-${sparrow_version}-x86_64.tar.gz
        elif    curl -sfI https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/Sparrowwallet-${sparrow_version}-x86_64.tar.gz ; then
                curl -LO https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/Sparrowwallet-${sparrow_version}-x86_64.tar.gz
        else
              sww "Unable to find file for Sparrow version $sparrow_version."
              return 1
        fi
    fi

    if [[ $chip == "aarch64" ]] ; then
        if   curl -sfI https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/sparrow-${sparrow_version}-aarch64.tar.gz ; then 
             curl -LO https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/sparrow-${sparrow_version}-aarch64.tar.gz 
        elif   curl -sfI https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/sparrowwallet-${sparrow_version}-aarch64.tar.gz ; then
               curl -LO https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/sparrowwallet-${sparrow_version}-aarch64.tar.gz 
        elif   curl -sfI https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/Sparrow-${sparrow_version}-aarch64.tar.gz ; then
             curl -LO https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/Sparrow-${sparrow_version}-aarch64.tar.gz 
        elif   curl -sfI https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/Sparrowwallet-${sparrow_version}-aarch64.tar.gz ; then
               curl -LO https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/Sparrowwallet-${sparrow_version}-aarch64.tar.gz 
        else
              sww "Unable to find file for Sparrow version $sparrow_version."
              return 1
        fi
    fi

fi

if [[ $OS == "Mac" ]] ; then

    if [[ $chip == "aarch64" || $(uname -m) == arm64 || $(uname -m) == ARM64 ]] ; then

        if   curl -sfI https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/Sparrow-${sparrow_version}-aarch64.dmg ; then
             curl -LO https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/Sparrow-${sparrow_version}-aarch64.dmg
        elif   curl -sfI https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/Sparrowwallet-${sparrow_version}-aarch64.dmg ; then
               curl -LO https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/Sparrowwallet-${sparrow_version}-aarch64.dmg
        elif   curl -sfI https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/sparrow-${sparrow_version}-aarch64.dmg ; then
               curl -LO https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/sparrow-${sparrow_version}-aarch64.dmg
        elif   curl -sfI https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/sparrowwallet-${sparrow_version}-aarch64.dmg ; then
               curl -LO https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/sparrowwallet-${sparrow_version}-aarch64.dmg
        else
              sww "Unable to find file for Sparrow version $sparrow_version."
              return 1
        fi
    fi

    if [[ $chip == "x86_64" ]] ; then
        if    curl -sfI https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/Sparrow-${sparrow_version}-x86_64.dmg ; then
              curl -LO https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/Sparrow-${sparrow_version}-x86_64.dmg
        elif    curl -sfI https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/Sparrowwallet-${sparrow_version}-x86_64.dmg ; then
                curl -LO https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/Sparrowwallet-${sparrow_version}-x86_64.dmg
        elif    curl -sfI https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/sparrow-${sparrow_version}-x86_64.dmg ; then
                curl -LO https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/sparrow-${sparrow_version}-x86_64.dmg
        elif    curl -sfI https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/sparrowwallet-${sparrow_version}-x86_64.dmg ; then
                curl -LO https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/sparrowwallet-${sparrow_version}-x86_64.dmg
        else
              sww "Unable to find file for Sparrow version $sparrow_version."
              return 1
        fi
    fi
fi

if   curl -sfI  https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/sparrow-${sparrow_version}-manifest.txt ; then
     curl -LO   https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/sparrow-${sparrow_version}-manifest.txt
elif  curl -sfI https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/Sparrow-${sparrow_version}-manifest.txt ; then
      curl -LO  https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/Sparrow-${sparrow_version}-manifest.txt 
else
        sww "Unable to find manifest file for Sparrow version $sparrow_version."
        return 1
fi

if curl -sfI https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/sparrow-${sparrow_version}-manifest.txt.asc ; then
   curl -LO https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/sparrow-${sparrow_version}-manifest.txt.asc
elif curl -sfI https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/Sparrow-${sparrow_version}-manifest.txt.asc ; then
     curl -LO https://github.com/sparrowwallet/sparrow/releases/download/${sparrow_version}/Sparrow-${sparrow_version}-manifest.txt.asc
else
        sww "Unable to find manifest file for Sparrow version $sparrow_version."
        return 1
fi

}
