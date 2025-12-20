function make_parmanode_tor_service {
if ! which tor >$dn 2>&1 ; then return 1 ; fi

if ! test -d $varlibtor >$dn 2>&1 ; then
    mkdir -p $varlibtor >$dn 2>&1
fi

if ! grep -q "parmanode_service" $pc 2>$dn ; then 
    if [[ ! -e $torrc ]] ; then return 1 
    fi
    echo "HiddenServiceDir $varlibtor/parmanode-service/" | sudo tee -a $torrc >$dn 2>&1
    echo "HiddenServicePort 6150 127.0.0.1:6150" | sudo tee -a $torrc >$dn 2>&1
    restart_tor
    parmanode_conf_remove "parmanode_service"
    parmanode_conf_add "parmanode_service=$(sudo cat $varlibtor/parmanode-service/hostname 2>$dn)"
fi
}