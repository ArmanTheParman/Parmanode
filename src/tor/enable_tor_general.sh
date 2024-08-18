function enable_tor_general {
if [[ $OS == "Mac" ]] ; then enable_tor_general_mac ; return 0 ; fi

if ! which tor >/dev/null 2>&1 ; then install_tor ; fi

if [[ ! -f /etc/tor/torrc ]] ; then
set_terminal ; echo "
########################################################################################
    /etc/tor/torrc file does not exist. You may have a non-standard Tor installation.
    Parmanode won't be able to automate this process for you. Sorry! Aborting.
########################################################################################
"
enter_continue ; return 1 ;
fi

please_wait

sudo usermod -a -G debian-tor $USER >/dev/null 2>&1

if ! sudo cat /etc/tor/torrc | grep "# Additions by Parmanode..." >/dev/null 2>&1 ; then
echo "# Additions by Parmanode..." | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
fi

if sudo grep "ControlPort 9051" /etc/tor/torrc | grep -v '^#' >/dev/null 2>&1 ; then true ; else
    echo "ControlPort 9051" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

if sudo grep "CookieAuthentication 1" /etc/tor/torrc | grep -v '^#' >/dev/null 2>&1 ; then true ; else
    echo "CookieAuthentication 1" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

if sudo grep "CookieAuthFileGroupReadable 1" /etc/tor/torrc | grep -v '^#' >/dev/null 2>&1 ; then true ; else
    echo "CookieAuthFileGroupReadable 1" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

if sudo grep "DataDirectoryGroupReadable 1" /etc/tor/torrc | grep -v '^#' >/dev/null 2>&1 ; then true ; else
    echo "DataDirectoryGroupReadable 1" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

}

function enable_tor_general_mac {

file=/usr/local/etc/tor/torrc

if [[ ! -e $file ]] ; then 
touch $file >/dev/null 2>&1
cat << EOF | sudo tee -a $file >/dev/null
# Additions by Parmanode...
ControlPort 9051
CookieAuthentication 1
CookieAuthFileGroupReadable 1
DataDirectoryGroupReadable 1
EOF
return 0
fi

if [[ ! -d /usr/local/etc/tor ]] ; then return 1 ; fi

if ! sudo cat $file | grep -q "# Additions by Parmanode..." >/dev/null 2>&1 ; then
echo "# Additions by Parmanode..." | sudo tee -a $file >/dev/null 2>&1
fi

if sudo grep "ControlPort 9051" $file | grep -qv '^#' >/dev/null 2>&1 ; then true ; else
    echo "ControlPort 9051" | sudo tee -a $file >/dev/null 2>&1
    fi

if sudo grep "CookieAuthentication 1" $file | grep -qv '^#' >/dev/null 2>&1 ; then true ; else
    echo "CookieAuthentication 1" | sudo tee -a $file >/dev/null 2>&1
    fi

if sudo grep "CookieAuthFileGroupReadable 1" $file | grep -qv '^#' >/dev/null 2>&1 ; then true ; else
    echo "CookieAuthFileGroupReadable 1" | sudo tee -a $file >/dev/null 2>&1
    fi

if sudo grep "DataDirectoryGroupReadable 1" $file | grep -qv '^#' >/dev/null 2>&1 ; then true ; else
    echo "DataDirectoryGroupReadable 1" | sudo tee -a $file >/dev/null 2>&1
    fi

}