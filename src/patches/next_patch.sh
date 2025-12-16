function next_patch { debugf
#for patch 11
make_bitcoind_service_file "setup"
make_electrs_serivce_file "setup"
make_fulcrum_serivce_file "setup"
make_electrumx_serivce_file "setup"
sudoers_patch #service files will be created and moved to /usr/local/parmanode for later access, so copy command added
return 0


}