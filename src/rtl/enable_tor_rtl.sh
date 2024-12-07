function enable_tor_rtl {

clear
enable_tor_general || return 1
clear
if sudo grep "HiddenServiceDir $macprefix/var/lib/tor/rtl-service/" \
    $macprefix/etc/tor/torrc | grep -v "^#" >$dn 2>&1 ; then true ; else
    echo "HiddenServiceDir $macprefix/var/lib/tor/rtl-service/" | sudo tee -a $macprefix/etc/tor/torrc >$dn 2>&1
    fi

if sudo grep "HiddenServicePort 7005 127.0.0.1:3000" \
    $macprefix/etc/tor/torrc | grep -v "^#" >$dn 2>&1 ; then true ; else
    echo "HiddenServicePort 7005 127.0.0.1:3000" | sudo tee -a $macprefix/etc/tor/torrc >$dn 2>&1
    fi

parmanode_conf_add "rtl_tor=true"

restart_tor
}

function disable_tor_rtl {
if [[ $OS == "Mac" ]] ; then return 1 ; fi
clear
file="$macprefix/etc/tor/torrc"

sudo gsed -i "/rtl-service/d" $file 
sudo gsed -i "/7005 127/d" $file 
parmanode_conf_remove "rtl_tor"
restart_tor
}