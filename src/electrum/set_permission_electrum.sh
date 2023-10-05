function set_permission_electrum {


if [[ $computer_type == "LinuxPC" ]] ; then
cd $HOME/parmanode/electrum
sudo chmod +x electrum*.AppImage 
fi

}
