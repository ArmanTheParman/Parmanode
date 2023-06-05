function set_permission_electrum {


if [[ $OS == "Linux" ]] ; then
cd $HOME/parmanode/electrum
sudo chmod +x electrum*.AppImage 
fi

}