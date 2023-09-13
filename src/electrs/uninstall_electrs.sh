function uninstall_electrs {
source $HOME/.parmanode/parmanode.conf

parmanode_conf_remove "electrs"

sudo systemctl stop electrs.service >/dev/null
sudo systemctl disable electrs.service >/dev/null
sudo rm /etc/systemd/system/electrs.servcie >/dev/null

if [[ $drive_electrs == "external" ]] ; then
sudo rm -rf /media/$USER/parmanode/electrs_db >/dev/null
fi

rm -rf $HOME/parmanode/electrs

installed_config_remove "electrs"

debug "end of uninstall"
}