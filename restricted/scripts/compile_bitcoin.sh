#!/bin/env bash

source /usr/local/parmanode/src/p4socket.sh

[[ $bitcoin_compile == "false" ]] && exit 0

if [[ $clientchoice == "knots" ]] ; then

    if [[ ${knotsversion%%.*} -lt 29 ]] ; then 
        newcompile="false"
    else
        newcompile="true"
    fi 

elif [[ $clientchoice == "deis" ]] ; then

    newcompile="false"

elif [[ $clientchoice == "core" ]] ; then

    if [[ ${version%%.*} -lt 29 ]] ; then 
        newcompile="false"
    else
        newcompile="true"
    fi 

fi

#to reduce errors on screen, making temporary git variables...
    export GIT_AUTHOR_NAME="Temporary Parmanode"
    export GIT_AUTHOR_EMAIL="parman@parmanode.parman"
    export GIT_COMMITTER_NAME="Parmanode Committer"
    export GIT_COMMITTER_EMAIL="parman@parmanode.parman"

/usr/local/parmanode/bitcoin_compile_dependency_script.sh

p4socket "####install_bitcoin#Downloading Bitcoin code from GitHub"

#for later when mac is supported
[[ $OS == "Mac" ]] && brew install berkeley-db@4

cd $hp || { p4socket "Can't change directory. Aborting." ; exit 1 ; }

[[ -e $hp/bitcoin_github ]] && rm -rf $hp/bitcoin_github >$dn 2>&1

if [[ $clientchoice == "core" ]] ; then  
    if [[ -e "$hp/bitcoin_github" ]] ; then 
        cd $hp/bitcoin_github ; git fetch ; git pull ; git checkout v$version ; git pull 
    else 
    git clone https://github.com/bitcoin/bitcoin.git bitcoin_github || { p4socket "Something went wrong with the download. Aborting." ; exit 1 ; }
    
    cd $hp/bitcoin_github || { p4socket "Unable to change to bitcoin_github directory. Aborting." ; exit 1 ; }
    #git fetch origin v$version -- use if doing depth 1
    git checkout v$version || { p4socket "Unable to checkout to the specified version. Aborting." ; exit 1 ; }
    fi

            #apply ordinals patch to v25 or v26
            if [[ $ordinals_patch == "true" ]] ; then
                git checkout -b parmanode_ordinals_patch #creates new branch
                curl -LO https://gist.githubusercontent.com/luke-jr/4c022839584020444915c84bdd825831/raw/555c8a1e1e0143571ad4ff394221573ee37d9a56/filter-ordinals.patch 
                git apply filter-ordinals.patch
                git add . ; git commit -m "ordinals patch applied"
            fi

elif [[ $clientchoice == "knots" ]] ; then 

    if [[ -e "$hp/bitcoinknots_github" ]] ; then 
        cd $hp/bitcoinknots_github ; git fetch ; git pull ; git checkout $knotstag ; git pull 
    else
        cd $hp && git clone https://github.com/bitcoinknots/bitcoin.git bitcoinknots_github && cd bitcoinknots_github && git checkout $knotstag
    fi
elif  [[ $clientchoice == "deis" ]] ; then #includes fileter ordinals patch
git clone https://github.com/armantheparman/deis bitcoin_github || { p4socket "Something went wrong with the download. Aborting." ; exit 1 ; }

cd $hp/bitcoin_github || { p4socket "Unable to change to bitcoin_github directory. Aborting." ; exit 1 ; }


#so qt is compiled for Deis...
export gui=yes 
fi
#clean up variables
    unset GIT_AUTHOR_NAME
    unset GIT_AUTHOR_EMAIL
    unset export GIT_COMMITTER_NAME
    unset export GIT_COMMITTER_EMAIL



##############################################################################################################
debug

p4socket "####install_bitcoin#Compiling"

if [[ $newcompile == "false" ]] ; then 

debug

./autogen.sh || p4socket "autogen.sh failed - this is normal if compiling versions greater than 28" 


./configure --with-gui=yes --enable-wallet --with-incompatible-bdb --with-utils || p4socket "configure failed"

#compile
make -j $(nproc) || p4socket  "Something went wrong with make." 

make -j $(nproc) check | p4socket "make check failed"

make install || p4socket "something went wrong with make install"

mv /usr/local/bin/*bitcoin* /usr/local/bin/parmanode/ >$dn 2>&1 || p4socket "moving binaries failed"
fi

#end newcompile=false

if [[ $newcompile == "true" ]] ; then
debug
gui=ON

mkdir build
cd build
cmake -GNinja \
      -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_GUI=$gui \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      ..

ninja -j $(nproc) || p4socket "ninja -j fail"
ninja install || p4socket "ninja install fail"

ls -lahf /usr/local/bin/bitcoind >$dn 2>&1 || p4socket "no bitcoind (1)"
debug
fi
#end newcopile=true

/usr/local/parmanode/p4run "bitcoin_binary_symlinks" 

ls -lahf /usr/local/bin/bitcoind >$dn 2>&1 || p4socket "no bitcoind (2)"

debug
exit 0