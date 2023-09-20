function set_permission_electrum {


if [[ $computer_type == "Linux" ]] ; then
cd $HOME/parmanode/electrum
sudo chmod +x electrum*.AppImage 
fi

}