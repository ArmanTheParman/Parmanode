function uninstall_electrs {
source $HOME/.parmanode/parmanode.conf

if [ -d $HOME/.electrs_backup ] ; then 

while true ; do
    set_terminal
    announce "A backup of electrs directory has been found in addition to the electrs" \
    "installation. Remove that too?    y    or    n ?"
    read choice
    case $choice in
    y|Y) rm -rf $HOME/.electrs_backup >/dev/null ;;
    *) invalid
    esac
done
fi


electrs_nginx remove

parmanode_conf_remove "electrs"

sudo systemctl stop electrs.service >/dev/null
sudo systemctl disable electrs.service >/dev/null
sudo rm /etc/systemd/system/electrs.servcie >/dev/null

if [[ $drive_electrs == "external" ]] ; then
sudo rm -rf /media/$USER/parmanode/electrs_db >/dev/null
fi

rm -rf $HOME/parmanode/electrs

parmanode_conf_remove "electrs"
installed_config_remove "electrs" ; debug "end of uninstall"
}