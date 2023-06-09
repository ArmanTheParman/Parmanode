function download_bitcoin_mac {
cd $HOME/parmanode/bitcoin
pre_install_mac

set_terminal ; echo "Downloading Bitcoin files to $HOME/parmanode/bitcoin ..."
if [[ $chip == "arm64" ]] ; then
curl -LO http://parman.org/downloadable/bitcoin_Mac_ARM_v24.0.1.tar || { echo " Download error. Aborting." ; enter_exit ; exit 1 ;}
    fi

if [[ $chip == "x86_64" ]] ; then
curl -LO http://parman.org/downloadable/bitcoin_Mac_x86-64_v24.0.1.tar || { echo " Download error. Aborting." ; enter_exit ; exit 1 ;}
    fi

set_terminal

#unpack Bitcoin core:

mkdir -p $HOME/.parmanode/temp/ >/dev/null 2>&1
tar -xf bitcoin_Mac* -C $HOME/.parmanode/temp >/dev/null 2>&1

sudo chown -R $(whoami):staff /$HOME/.parmanode/temp/
sudo chmod -R 0755 $HOME/.parmanode/temp/

if [[ -d /usr/local/bin ]] ; then true ; else sudo mkdir -p /usr/local/bin ]] ; fi
sudo mv $HOME/.parmanode/temp/* /usr/local/bin
sudo rm -rf $HOME/.parmanode/temp

return 0      
}
