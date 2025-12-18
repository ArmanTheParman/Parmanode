function next_patch { debugf

sudo /usr/local/parmanode/scripts/patchrunner.sh >$dn 2>&1
#for patch 11
make_bitcoind_service_file "setup"
make_electrs_service "setup"
make_fulcrum_service_file "setup"
make_electrumx_service "setup"
sudoers_patch #service files will be created and moved to /usr/local/parmanode for later access, so copy command added
make_restricted_bucket #version 2
return 0


}