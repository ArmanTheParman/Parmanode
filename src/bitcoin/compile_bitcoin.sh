function compile_bitcoin { debugf
debug "regular compile bitcoin function called"


[[ $version == "self" ]] && return 0 
[[ $bitcoin_compile == "false" ]] && return 0 

if [[ $clientchoice == "knots" ]] ; then

    if [[ ${knotsversion%%.*} -lt 29 ]] ; then 
        export newcompile="false"
    else
        export newcompile="true"
    fi 

elif [[ $clientchoice == "deis" ]] ; then

    export newcompile="false"

elif [[ $clientchoice == "core" ]] ; then

    if [[ ${version%%.*} -lt 29 ]] ; then 
        export newcompile="false"
    else
        export newcompile="true"
    fi 

fi

if [[ $parmaview == 1 ]] ; then
debug "calling bitcoin compile dependencies from parmanode view"
sudo /usr/local/parmanode/p4run "compile bitcoin" || debug "call to compile script failed"
return 0
fi

debug "newcompile: $newcompile"

#to reduce errors on screen, making temporary git variables...
    export GIT_AUTHOR_NAME="Temporary Parmanode"
    export GIT_AUTHOR_EMAIL="parman@parmanode.parman"
    export GIT_COMMITTER_NAME="Parmanode Committer"
    export GIT_COMMITTER_EMAIL="parman@parmanode.parman"

bitcoin_compile_dependencies || return 1
debug
p4socket "####install_bitcoin#Downloading Bitcoin code from GitHub"

#for later when mac is supported
[[ $OS == "Mac" ]] && brew install berkeley-db@4

cd $hp || { enter_continue "Can't change directory. Aborting." ; return 1 ; }

[[ -e $hp/bitcoin_github ]] && $xsudo rm -rf $hp/bitcoin_github >$dn 2>&1

if [[ $clientchoice == "core" ]] ; then  
    if [[ -e "$hp/bitcoin_github" ]] ; then 
        cd $hp/bitcoin_github ; git fetch ; git pull ; git checkout v$version ; git pull 
    else 
    git clone https://github.com/bitcoin/bitcoin.git bitcoin_github || { announce "Something went wrong with the download. Aborting." ; return 1 ; }
    
    cd $hp/bitcoin_github || { announce "Unable to change to bitcoin_github directory. Aborting." ; return 1 ; }
    #git fetch origin v$version -- use if doing depth 1
    git checkout v$version || { announce "Unable to checkout to the specified version. Aborting." ; return 1 ; }
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
git clone https://github.com/armantheparman/deis bitcoin_github || { announce "Something went wrong with the download. Aborting." ; return 1 ; }

cd $hp/bitcoin_github || { announce "Unable to change to bitcoin_github directory. Aborting." ; return 1 ; }


### these changes are not part of Bitcoin Deis repo, but kept here for historical reasons.
# #res/icons
# cp $pn/src/deis/icons/deis.png $hp/bitcoin_github/src/qt/res/icons/bitcoin.png
# cp $pn/src/deis/icons/deis.ico $hp/bitcoin_github/src/qt/res/icons/bitcoin.ico
# #svg
# cp $pn/src/deis/deis.svg $hp/bitcoin_github/src/qt/res/src/bitcoin.svg
# #doc
# cp $pn/src/deis/share/icons/pixmaps/deis64.png $hp/bitcoin_github/doc/bitcoin_logo_doxygen.png
# #share/pixmaps
# rm $hp/bitcoin_github/share/pixmaps/*
# cp $pn/src/deis/share/pixmaps/* $hp/bitcoin_github/share/pixmaps/*

#     for file in $(find $hp/bitcoin_github -type f) ; do
#         gsed -i "s/Bitcoin Core/Bitcoin Deis/g" $file
#     done

#so qt is compiled for Deis...
export gui=yes 
fi
#clean up variables
    unset GIT_AUTHOR_NAME
    unset GIT_AUTHOR_EMAIL
    unset export GIT_COMMITTER_NAME
    unset export GIT_COMMITTER_EMAIL


! [[ $clientchoice == "deis" ]] && while true ; do
set_terminal ; echo -e "
########################################################################################

    Bitcoin can be compiled with or without a Graphical User Interface (GUI).

    Parmanode does not need a GUI, as it is itself the interface between you and the
    node's functions - this is partly what Parmanode is for.

    You have choices...
$green
              1)   Compile Bitcoin WITHOUT a GUI (recommended, and faster) 
$cyan
              2)   Compile bitcoin WITH a GUI
$orange
########################################################################################
"
choose "xpmq" && read choice
[[ $parmaview == 1 ]] && choice=1
case $choice in
q|Q) exit 0 ;; p|P|M|m) back2main ;;
1) export gui=no ; break ;;
2) export gui=yes ; 
bitcoin_compile_dependencies "GUI" || return 1
break ;;
*) invalid ;;
esac
done
##############################################################################################################
debug

p4socket "####install_bitcoin#Compiling"

if [[ $newcompile == "false" ]] ; then 
debug
    ./autogen.sh || { enter_continue "autogen.sh failed - this is normal if compiling versions greater than 28" ; }

while true ; do
clear ; echo -e "
########################################################################################

   The configure command that will be run is the following: 

$cyan
   ./configure --with-gui=$gui --enable-wallet --with-incompatible-bdb --with-utils
$orange

   Hit$green <enter>$orange to continue, or,$yellow type in$orange additional options you
   may have researched yourself and would like to include, then hit$green <enter>$orange

   The default will be chosen in 30 seconds

########################################################################################
"
options="" #safety, redundant
{ [[ $parmaview != 1 ]] && read -t 30 options ; } || options="" 
clear
case $options in
"") break ;;
*)
clear
echo -e "
########################################################################################

    You have entered $options

    Hit y to accept, or n to try again.

########################################################################################
"
    [[ $parmaview != 1 ]] && read choice
    [[ $parmaview == 1 ]] && choice=y
    
    case $choice in
    y) break ;; *) continue ;;
    esac
;;
esac
done

set_terminal


./configure --with-gui=$gui --enable-wallet --with-incompatible-bdb --with-utils $options || {
echo -e "
########################################################################################

    If you saw no errors, hit $cyan<enter>$orange to continue.

    Otherwise exit, and correct the error yourself, or report to Parman via Telegram 
    chat group for help.

    Continuing compiling in 10 seconds.

########################################################################################
"
choose "epmq"
{ [[ $parmaview != 1 ]] && read -t 10 choice ; } || choice="" ; set_terminal
jump $choice 
case $choice in q|Q) exit ;; p|P|M|m) back2main ;; esac
}

while true ; do
set_terminal
# j will be set to $(nproc) or user choice
echo -e "
########################################################################################

    Running make command...
$green
    make -j $(nproc)
$orange
    If you would like to override the j value, hit 'o' now, otherwise hit <enter>
    to continue.

$pink
    FYI, the j value is the number of core processors to use to compile. Parmanode
    has worked out the max value for you.
$orange

    Continuing with default in 10 seconds.

########################################################################################
"
[[ $parmaview == 1 ]] && { j=$(nproc) ; break ; }
[[ $parmaview != 1 ]] && read -t 10 choice 

if [[ $choice != o ]] ; then j=$(nproc) ; break ; fi

clear
echo -e "
########################################################################################

    Please enter the$green j$orange value you wish to use, then hit enter.

########################################################################################
"
read j
set_terminal
echo -e "
########################################################################################

    You have chosen $j for the j value. <enter> to continue, or$cyan n$orange and <enter> 
    to try again.

########################################################################################
"
read choice2
if [[ $choice2 == "" ]] ; then break ; fi
done
clear
echo "Running make command, please wait..."
sleep 3

#compile
make -j $j || enter_continue "Something might have gone wrong." 


set_terminal
echo -e "
########################################################################################
$cyan
    Running tests.$orange Will only take a few minutes. 

    The output is will be saved to the file:
$green
    $HOME/.parmanode/bitcoin_compile_check.log
$orange

    Hit$cyan <enter>$orange to continue, or continuing in 10 seconds.

########################################################################################

"
[[ $parmaview != 1 ]] && read -t 10
[[ $parmaview != 1 ]] && please_wait_no_clear

[[ -n $j ]] && j=1

$xsudo make -j $j check | tee $dp/bitcoin_compile_check.log

echo -e "$orange
########################################################################################

    Tests done. Hit $cyan<enter>$orange to continue on to the installation (copies binaries
    to system wide directories) Continuing in 10 seconds.

    If you saw errors, hit$cyan x$orange to abandon the installation. You would need 
    to then uninstall the partial bitcoin installation before you can try again.

    Note: If you selected ordinals patch, then some transaction tests failing would
    be normal. Carry on.

    For Knots Bitcoin, if you see some bitcoin.ico error, it's probably safe to 
    continue, it's just an icon file.

########################################################################################
"
[[ $parmaview != 1 ]] && {
choose "xpmq"
read -t 10 choice || choice=""
clear
case $choice in
q|Q) exit 0 ;; p|P|M|m|x|X) back2main ;;
esac
}

$xsudo make install || enter_continue "something might have gone wrong here."
$xsudo mv /usr/local/bin/*bitcoin* /usr/local/bin/parmanode/ >$dn 2>&1
fi

#end newcompile=false

if [[ $newcompile == "true" ]] ; then
debug
[[ $gui == "yes" ]] && gui=ON
[[ $gui == "no" ]] && gui=OFF

mkdir build
cd build
cmake -GNinja \
      -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_GUI=$gui \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      ..
ninja -j $(nproc) || p4socket "ninja -j fail"
sudo ninja install || p4socket "ninja install fail"
ls -lahf /usr/local/bin/bitcoind >$dn 2>&1 || p4socket "no bitcoind (1)"
debug
fi
#end newcopile=true

symlinks_for_bitcoin_binaries >$dn 2>&1
ls -lahf /usr/local/bin/bitcoind >$dn 2>&1 || p4socket "no bitcoind (2)"
debug
}

function bitcoin_compile_dependencies { debugf


if [[ -z $1 ]] ; then 
set_terminal ; echo -e "${pink}Upgrading, and installing dependencies to compile bitcoin...$orange"
sudo apt-get update -y && export APT_UPDATE="true"
sudo apt-get --fix-broken install -y
sudo apt-get install -y make              || { [[ $parmaview != 1 ]] && enter_continue "Something went wrong with make.$green i$orange to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y automake          || { [[ $parmaview != 1 ]] && enter_continue "Something went wrong with automake.$green i$orange to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y cmake             || { [[ $parmaview != 1 ]] && enter_continue "Something went wrong with cmake.$green i$orange to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y curl              || { [[ $parmaview != 1 ]] && enter_continue "Something went wrong with curl.$green i$orange to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y g++-multilib      
sudo apt-get install -y libtool           || { [[ $parmaview != 1 ]] && enter_continue "Something went wrong with libtool.$green i$orange to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y binutils          || { [[ $parmaview != 1 ]] && enter_continue "Something went wrong with binutils.$green i$orange to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y bsdmainutils      || { [[ $parmaview != 1 ]] && enter_continue "Something went wrong with bsdmainutils.$green i$orange to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y build-essential   || { [[ $parmaview != 1 ]] && enter_continue "Something went wrong with build-essential.$green i$orange to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y autotools-dev     || { [[ $parmaview != 1 ]] && enter_continue "Something went wrong with autotools-dev.$green i$orange to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y pkg-config        || { [[ $parmaview != 1 ]] && enter_continue "Something went wrong with pkg-config.$green i$orange to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y ninja-build       || { [[ $parmaview != 1 ]] && enter_continue "Something went wrong with ninja-build.$green i$orange to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y python3           || { [[ $parmaview != 1 ]] && enter_continue "Something went wrong with python3.$green i$orange to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y patch             || { [[ $parmaview != 1 ]] && enter_continue "Something went wrong with patch.$green i$orange to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y autoconf          || { [[ $parmaview != 1 ]] && enter_continue "Something went wrong with autoconf.$green i$orange to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y libboost-all-dev  || { [[ $parmaview != 1 ]] && enter_continue "Something went wrong with libboost-all-dev.$green i$orange to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y imagemagick       || { [[ $parmaview != 1 ]] && enter_continue "Something went wrong with imagemagick.$green i$orange to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y librsvg2-bin      || { [[ $parmaview != 1 ]] && enter_continue "Something went wrong with librsvg2-bin.$green i$orange to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y libdb-dev         || { [[ $parmaview != 1 ]] && enter_continue "Something went wrong with libdb-dev.$green i$orange to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y libdb++-dev       || { [[ $parmaview != 1 ]] && enter_continue "Something went wrong with libdb++-dev.$green i$orange to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y libzmq3-dev       || { [[ $parmaview != 1 ]] && enter_continue "Something went wrong with libzmq3-dev.$green i$orange to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y libqrencode-dev   || { [[ $parmaview != 1 ]] && enter_continue "Something went wrong with libqrencode-dev.$green i$orange to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y libsqlite3-dev    || { [[ $parmaview != 1 ]] && enter_continue "Something went wrong with libsqlite3-dev.$green i$orange to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y libevent-dev      || { [[ $parmaview != 1 ]] && enter_continue "Something went wrong with libevent-dev.$green i$orange to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y libssl-dev        || { [[ $parmaview != 1 ]] && enter_continue "Something went wrong with libssl-dev.$green i$orange to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y libminiupnpc-dev  || { [[ $parmaview != 1 ]] && enter_continue "Something went wrong with libminiupnpc-dev.$green i$orange to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y libprotobuf-dev   || { [[ $parmaview != 1 ]] && enter_continue "Something went wrong with libprotobuf-dev.$green i$orange to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y protobuf-compiler || { [[ $parmaview != 1 ]] && enter_continue "Something went wrong with protobuf-compiler.$green i$orange to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
fi

if [[ $1 == "GUI" ]] ; then

sudo apt-get install -y qtchooser 
sudo apt-get install -y qtbase5-dev-tools
sudo apt-get install -y qtcreator          || { [[ $parmaview != 1 ]] && enter_continue "Something went wrong with qtcreator.$green i$orange to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y qtbase5-dev        || { [[ $parmaview != 1 ]] && enter_continue "Something went wrong with qtbase5-dev.$green i$orange to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y qt5-qmake          || { [[ $parmaview != 1 ]] && enter_continue "Something went wrong with qt5-qmake.$green i$orange to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y qttools5-dev-tools || { [[ $parmaview != 1 ]] && enter_continue "Something went wrong with qttools5-dev-tools.$green i$orange to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y qtchooser          || { [[ $parmaview != 1 ]] && enter_continue "Something went wrong with qtchooser.$green i$orange to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y libqt5gui5         || { [[ $parmaview != 1 ]] && enter_continue "Something went wrong with libqt5gui5.$green i$orange to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y libqt5core5a       || { [[ $parmaview != 1 ]] && enter_continue "Something went wrong with libqt5core5a.$green i$orange to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y libqt5dbus5        || { [[ $parmaview != 1 ]] && enter_continue "Something went wrong with libqt5dbus5.$green i$orange to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y qttools5-dev       || { [[ $parmaview != 1 ]] && enter_continue "Something went wrong with qttools5-dev.$green i$orange to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y libqt5widgets5     || { [[ $parmaview != 1 ]] && enter_continue "Something went wrong with libqt5widgets5.$green i$orange to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
return 0
fi
}
