function download_electrs {
cd $HOME/parmanode/ && git clone --branch $electrsversion --single-branch https://github.com/romanz/electrs 2>$dn && installed_config_add "electrs2-start"
}