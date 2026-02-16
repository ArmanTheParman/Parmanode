function enable_bre_tor {

if ! which tor >$dn 2>&1 ; then install_tor ; fi
if ! sudo test -e $torrc ; then
set_terminal ; echo -e "
########################################################################################
$cyan    $torrc$orange file does not exist. You may have a non-standard Tor installation.
    Parmanode won't be able to automate this process for you. Sorry! Aborting.
########################################################################################
"
enter_continue ; return 1 ;
fi
please_wait

if ! id | grep -q "debian-tor" ; then sudo usermod -aG debian-tor $USER >$dn 2>&1 ; fi

if ! $xsudo grep "Additions by Parmanode" $torrc >$dn 2>&1 ; then
echo "# Additions by Parmanode..." | sudo tee -a $torrc >$dn 2>&1
fi

enable_tor_general

# if there's this search string, that doesn't start with #, then...
if ! sudo grep "HiddenServiceDir $varlibtor/bre-service/" $torrc | grep -v "^#" >$dn 2>&1 ; then 
    echo "HiddenServiceDir $varlibtor/bre-service/" | sudo tee -a $torrc >$dn 2>&1
fi

if ! sudo grep "HiddenServicePort 3004 127.0.0.1:3002" $torrc | grep -v "^#" >$dn 2>&1 ; then 
    echo "HiddenServicePort 3004 127.0.0.1:3002" | sudo tee -a $torrc >$dn 2>&1
fi

restart_tor
restart_bre 
get_onion_address_variable "bre" 
clear
enter_continue "
########################################################################################

    Changes have been made to the$cyan torrc$orange file to create/enable a hidden service
    for BRE. Please give it a few moments to work - initially, it may still appear
    disabled, but give it a minute.

########################################################################################
"
}

