function next_patch { debugf

#introduce a scripts directory. Needs some refactoring --- add to patch function later
test -d $dp/scripts || mkdir -p $dp/scripts >$dn 2>&1

test -f $dp/.udev_patch || {
    udev_patch && touch $dp/.udev_patch
}
#make part of installation later
mkdir -p $HOME/.ssh/extra_keys >$dn 2>&1
$xsudo mv ~/.ssh/*-key* $HOME/.ssh/extra_keys/ >$dn 2>&1
[[ -f ~/.ssh/config ]] && 
! grep -q 'extra_keys' ~/.ssh/config && 
$xsudo gsed -E -i 's|^IdentityFile ~/.ssh/(.*-key)$|IdentityFile ~/.ssh/extra_keys/\1|' ~/.ssh/config >$dn 2>&1

#for patch 11
make_restricted_bucket
sudoers_patch #service files will be created and moved to /usr/local/parmanode for later access, so copy command added
make_bitcoind_service_file "setup"
make_electrs_service "setup"
make_fulcrum_service_file "setup"
make_electrumx_service "setup"
return 0
}
