function patch_9 {
make_external_IP_script
fulcrum_service_patch 
which tor >$dn && ! grep -q tor-end $ic && installed_conf_add "tor-end"
parmanode_conf_remove "lndlogfirsttime"
}