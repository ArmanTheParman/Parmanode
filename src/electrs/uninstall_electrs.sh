function uninstall_electrs {

parmanode_conf_remove "electrs"

sudo systemctl stop electrs.service >/dev/null
sudo systemctl disable electrs.service >/dev/null
sudo rm /etc/systemd/system/electrs.servcie >/dev/null

installed_config_remove "electrs"
}