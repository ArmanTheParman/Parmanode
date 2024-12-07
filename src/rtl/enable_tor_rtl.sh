function enable_tor_rtl {

clear
enable_tor_general || return 1
clear
if sudo grep "HiddenServiceDir $varlibtor/rtl-service/" \
    $torrc | grep -v "^#" >$dn 2>&1 ; then true ; else
    echo "HiddenServiceDir $varlibtor/rtl-service/" | sudo tee -a $torrc >$dn 2>&1
    fi

if sudo grep "HiddenServicePort 7005 127.0.0.1:3000" \
    $torrc | grep -v "^#" >$dn 2>&1 ; then true ; else
    echo "HiddenServicePort 7005 127.0.0.1:3000" | sudo tee -a $torrc >$dn 2>&1
    fi

parmanode_conf_add "rtl_tor=true"

restart_tor
}

function disable_tor_rtl {

sudo gsed -i "/rtl-service/d" $torrc
sudo gsed -i "/7005 127/d" $torrc
parmanode_conf_remove "rtl_tor"
restart_tor
}