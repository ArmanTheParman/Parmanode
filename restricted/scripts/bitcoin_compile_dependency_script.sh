#!/bin/env bash

source /usr/local/parmanode/src/p4socket.sh

apt-get update -y 
apt-get --fix-broken install -y

apt-get install -y make              || p4socket "Error with apt-get install make"
apt-get install -y automake          || p4socket "Error with apt-get install automake"
apt-get install -y cmake             || p4socket "Error with apt-get install cmake"
apt-get install -y curl              || p4socket "Error with apt-get install curl"
apt-get install -y g++-multilib     
apt-get install -y libtool           || p4socket "Error with apt-get install g++-multilib"
apt-get install -y binutils          || p4socket "Error with apt-get install binutils"
apt-get install -y bsdmainutils      || p4socket "Error with apt-get install bsdmainutils"
apt-get install -y build-essential   || p4socket "Error with apt-get install build-essential"
apt-get install -y autotools-dev     || p4socket "Error with apt-get install autotools-dev"
apt-get install -y pkg-config        || p4socket "Error with apt-get install pkg-config"
apt-get install -y ninja-build       || p4socket "Error with apt-get install ninja-build"
apt-get install -y python3           || p4socket "Error with apt-get install python3"
apt-get install -y patch             || p4socket "Error with apt-get install patch"
apt-get install -y autoconf          || p4socket "Error with apt-get install autoconf"
apt-get install -y libboost-all-dev  || p4socket "Error with apt-get install libboost-all-dev"
apt-get install -y imagemagick       || p4socket "Error with apt-get install imagemagick"
apt-get install -y librsvg2-bin      || p4socket "Error with apt-get install librsvg2-bin"
apt-get install -y libdb-dev         || p4socket "Error with apt-get install libdb-dev"
apt-get install -y libdb++-dev       || p4socket "Error with apt-get install libdb++-dev"
apt-get install -y libzmq3-dev       || p4socket "Error with apt-get install libzmq3-dev"
apt-get install -y libqrencode-dev   || p4socket "Error with apt-get install libqrencode-dev"
apt-get install -y libsqlite3-dev    || p4socket "Error with apt-get install libsqlite3-dev"
apt-get install -y libevent-dev      || p4socket "Error with apt-get install libevent-dev"
apt-get install -y libssl-dev        || p4socket "Error with apt-get install libssl-dev"
apt-get install -y libminiupnpc-dev  || p4socket "Error with apt-get install libminiupnpc-dev"
apt-get install -y libprotobuf-dev   || p4socket "Error with apt-get install libprotobuf-dev"
apt-get install -y protobuf-compiler || p4socket "Error with apt-get install protobuf-compiler"

#GUI
apt-get install -y qtchooser 
apt-get install -y qtbase5-dev-tools
apt-get install -y qtcreator          || p4socket "Error with qtcreator"
apt-get install -y qtbase5-dev        || p4socket "Error with qtbase5-dev"
apt-get install -y qt5-qmake          || p4socket "Error with qmake"
apt-get install -y qttools5-dev-tools || p4socket "Error with qttols5-dev-tools"
apt-get install -y qtchooser          || p4socket "Error with qtchooser"
apt-get install -y libqt5gui5         || p4socket "Error with libqt5gui5"
apt-get install -y libqt5core5a       || p4socket "Error with libqt5core5a"
apt-get install -y libqt5dbus5        || p4socket "Error with libqt5dbus5"
apt-get install -y qttools5-dev       || p4socket "Error with qttols5-dev"
apt-get install -y libqt5widgets5     || p4socket "Error with libqt5widgets5"

exit 0 