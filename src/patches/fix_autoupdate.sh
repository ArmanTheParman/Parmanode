function fix_autoupdate {

source $HOME/.parmanode/parmanode.conf
if [[ $autoupdate == true ]] ; then
crontab -l ; echo "30 3 * * *  [ -x $HOME/.parmanode/update_script.sh ] && $HOME/.parmanode/update_script.sh" | crontab -
parmanode_conf_remove "autoupdated="
parmanode_conf_add "autoupdate_version2=true"
fi
}