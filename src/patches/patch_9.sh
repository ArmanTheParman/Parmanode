function patch_9 {
remove_tor_log_patch
please_wait
[[ -d /usr/local/bin ]] && sudo strip /usr/local/bin/* >/dev/null 2>&1 
make_external_IP_script
fulcrum_service_patch 
fulcrum_delete_old_log
which tor >$dn && ! grep -q tor-end $ic && installed_conf_add "tor-end"
sudo test -e /etc/sudoers.d/parmanode_extend_sudo_timeout || echo "Defaults:$USER timestamp_timeout=45" | sudo tee /etc/sudoers.d/parmanode_extend_sudo_timeout >/dev/null
parmanode_conf_remove "lndlogfirsttime"
parmanode_conf_remove "patch="
parmanode_conf_add "patch=9"
}