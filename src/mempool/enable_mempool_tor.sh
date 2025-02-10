function enable_mempool_tor {
if ! which tor >$dn 2>&1 ; then install_tor ; fi   

please_wait

if  [[ $OS == "Linux" ]] &&  grep -q "debian-tor" /etc/group >$dn 2>&1 ; then
    sudo usermod -a -G debian-tor $USER >$dn 2>&1
fi

if ! sudo cat $torrc | grep "# Additions by Parmanode..." >$dn 2>&1 ; then
echo "# Additions by Parmanode..." | sudo tee -a $torrc >$dn 2>&1
fi

if ! sudo grep "ControlPort 9051" $torrc | grep -v '^#' >$dn 2>&1 ; then 
    echo "ControlPort 9051" | sudo tee -a $torrc >$dn 2>&1
fi

if ! sudo grep "CookieAuthentication 1" $torrc | grep -v '^#' >$dn 2>&1 ; then 
    echo "CookieAuthentication 1" | sudo tee -a $torrc >$dn 2>&1
fi

if ! sudo grep "CookieAuthFileGroupReadable 1" $torrc | grep -v '^#' >$dn 2>&1 ; then 
    echo "CookieAuthFileGroupReadable 1" | sudo tee -a $torrc >$dn 2>&1
fi

if ! sudo grep "DataDirectoryGroupReadable 1" $torrc | grep -v '^#' >$dn 2>&1 ; then 
    echo "DataDirectoryGroupReadable 1" | sudo tee -a $torrc >$dn 2>&1
fi

# if there's this search string, that doesn't start with #, then...
if ! sudo grep "HiddenServiceDir $varlibtor/mempool-service/" $torrc| grep -v "^#" >$dn 2>&1 ; then 
    echo "HiddenServiceDir $varlibtor/mempool-service/" | sudo tee -a $torrc >$dn 2>&1
fi

if ! sudo grep "HiddenServicePort 8280 127.0.0.1:8180"  $torrc | grep -v "^#" >$dn 2>&1 ; then 
    echo "HiddenServicePort 8280 127.0.0.1:8180" | sudo tee -a $torrc >$dn 2>&1
fi

restart_tor
restart_mempool 
get_onion_address_variable "mempool" 
announce "FYI, changes have been made to torrc file, and Tor has been restarted."
return 0
}

function disable_mempool_tor {
sudo gsed -i "/mempool-service/d" $torrc 
sudo gsed -i "/127.0.0.1:8180/d" $torrc
restart_tor
restart_mempool 
announce "FYI, changes have been made to$cyan torrc$orange file, and Tor has been restarted."
}