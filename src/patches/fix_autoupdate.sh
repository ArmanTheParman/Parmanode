function fix_autoupdate {

source $HOME/.parmanode/parmanode.conf
if [[ $autoupdate == true ]] ; then
echo "30 3 * * *  [ -x $HOME/.parmanode/update_script.sh ] && $HOME/.parmanode/update_script.sh" | sudo tee -a /etc/crontab >/dev/null 2>&1
parmanode_conf_remove "autoupdated="
parmanode_conf_add "autoupdate_version2=true"
fi
}