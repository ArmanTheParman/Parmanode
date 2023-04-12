function download_bitcoin_mac {
cd $HOME/parmanode/bitcoin
pre_install_mac

set_terminal ; echo "Downloading Bitcoin files to $HOME/parmanode/bitcoin ..."
if [[ $chip == "arm64" ]] ; then
wget http://parman.org/downloadable/bitcoin_Mac_ARM_v24.0.1.tar || { echo " Download error. Aborting." ; enter_exit ; exit 1 ;}
    fi

if [[ $chip == "x86_64" ]] ; then
wget http://parman.org/downloadable/bitcoin_Mac_x86-64_v24.0.1.tar || { echo " Download error. Aborting." ; enter_exit ; exit 1 ;}
    fi

set_terminal

#unpack Bitcoin core:

mkdir $HOME/.parmanode/temp/ >/dev/null 2>&1
tar -xf bitcoin_Mac* -C $HOME/.parmanode/temp >/dev/null 2>&1

#"installs" bitcoin and sets to writing to only root for security. Read/execute for group and others.
sudo install -m 0755 -o root -g root -t /usr/local/bin $HOME/.parmanode/temp/bitcoin*

sudo rm -rf $HOME/.parmanode/temp
return 0      # abort bitoin installation if return 1
}
