function patch_9 {
remove_tor_log_patch
debug p9 3
please_wait
[[ -d /usr/local/bin ]] && sudo strip /usr/local/bin/* >/dev/null 2>&1 
debug p9 5
make_external_IP_script
debug p9 7 
fulcrum_service_patch 
debug p9 9
fulcrum_delete_old_log
debug p9 11
which tor >$dn && ! grep -q tor-end $ic && installed_conf_add "tor-end"
debug p9 13
sudo test -e /etc/sudoers.d/parmanode_extend_sudo_timeout || echo "Defaults:$USER timestamp_timeout=45" | sudo tee /etc/sudoers.d/parmanode_extend_sudo_timeout >/dev/null
debub p9 15
parmanode_conf_remove "lndlogfirsttime"
debug p9 17
parmanode_conf_remove "patch="
parmanode_conf_add "patch=9"
debug end p9
}