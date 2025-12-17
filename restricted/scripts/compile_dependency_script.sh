#!/bin/env bash

sudo apt-get update -y && export APT_UPDATE="true"
sudo apt-get --fix-broken install -y
sudo apt-get install -y make              || p4socket "Error with apt-get install make"
sudo apt-get install -y automake          || p4socket "Error with apt-get install automake"
sudo apt-get install -y cmake             || p4socket "Error with apt-get install cmake"
sudo apt-get install -y curl              || p4socket "Error with apt-get install curl"
sudo apt-get install -y g++-multilib     
sudo apt-get install -y libtool           || p4socket "Error with apt-get install g++-multilib"
sudo apt-get install -y binutils          || p4socket "Error with apt-get install binutils"
sudo apt-get install -y bsdmainutils      || p4socket "Error with apt-get install bsdmainutils"
sudo apt-get install -y build-essential   || p4socket "Error with apt-get install build-essential"
sudo apt-get install -y autotools-dev     || p4socket "Error with apt-get install autotools-dev"
sudo apt-get install -y pkg-config        || p4socket "Error with apt-get install pkg-config"
sudo apt-get install -y ninja-build       || p4socket "Error with apt-get install ninja-build"
sudo apt-get install -y python3           || p4socket "Error with apt-get install python3"
sudo apt-get install -y patch             || p4socket "Error with apt-get install patch"
sudo apt-get install -y autoconf          || p4socket "Error with apt-get install autoconf"
sudo apt-get install -y libboost-all-dev  || p4socket "Error with apt-get install libboost-all-dev"
sudo apt-get install -y imagemagick       || p4socket "Error with apt-get install imagemagick"
sudo apt-get install -y librsvg2-bin      || p4socket "Error with apt-get install librsvg2-bin"
sudo apt-get install -y libdb-dev         || p4socket "Error with apt-get install libdb-dev"
sudo apt-get install -y libdb++-dev       || p4socket "Error with apt-get install libdb++-dev"
sudo apt-get install -y libzmq3-dev       || p4socket "Error with apt-get install libzmq3-dev"
sudo apt-get install -y libqrencode-dev   || p4socket "Error with apt-get install libqrencode-dev"
sudo apt-get install -y libsqlite3-dev    || p4socket "Error with apt-get install libsqlite3-dev"
sudo apt-get install -y libevent-dev      || p4socket "Error with apt-get install libevent-dev"
sudo apt-get install -y libssl-dev        || p4socket "Error with apt-get install libssl-dev"
sudo apt-get install -y libminiupnpc-dev  || p4socket "Error with apt-get install libminiupnpc-dev"
sudo apt-get install -y libprotobuf-dev   || p4socket "Error with apt-get install libprotobuf-dev"
sudo apt-get install -y protobuf-compiler || p4socket "Error with apt-get install protobuf-compiler"

if [[ $GUI == "no" ]] ; then exit 0 ; fi

sudo apt-get install -y qtchooser 
sudo apt-get install -y qtbase5-dev-tools
sudo apt-get install -y qtcreator          || p4socket "Error with qtcreator"
sudo apt-get install -y qtbase5-dev        || p4socket "Error with qtbase5-dev"
sudo apt-get install -y qt5-qmake          || p4socket "Error with qmake"
sudo apt-get install -y qttools5-dev-tools || p4socket "Error with qttols5-dev-tools"
sudo apt-get install -y qtchooser          || p4socket "Error with qtchooser"
sudo apt-get install -y libqt5gui5         || p4socket "Error with libqt5gui5"
sudo apt-get install -y libqt5core5a       || p4socket "Error with libqt5core5a"
sudo apt-get install -y libqt5dbus5        || p4socket "Error with libqt5dbus5"
sudo apt-get install -y qttools5-dev       || p4socket "Error with qttols5-dev"
sudo apt-get install -y libqt5widgets5     || p4socket "Error with libqt5widgets5"

exit 0 