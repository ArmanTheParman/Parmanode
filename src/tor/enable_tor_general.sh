function enable_tor_general {
if [[ $OS == "Mac" ]] ; then enable_tor_general_mac ; return 0 ; fi

if ! which tor >$dn 2>&1 ; then install_tor ; fi

if [[ ! -f /etc/tor/torrc ]] 2>$dn ; then
return 1 ;
fi

sudo usermod -a -G debian-tor $USER >$dn 2>&1

if ! sudo cat /etc/tor/torrc | grep "# Additions by Parmanode..." >$dn 2>&1 ; then
echo "# Additions by Parmanode..." | sudo tee -a /etc/tor/torrc >$dn 2>&1
fi

if sudo grep "ControlPort 9051" /etc/tor/torrc | grep -v '^#' >$dn 2>&1 ; then true ; else
    echo "ControlPort 9051" | sudo tee -a /etc/tor/torrc >$dn 2>&1
    fi

if sudo grep "CookieAuthentication 1" /etc/tor/torrc | grep -v '^#' >$dn 2>&1 ; then true ; else
    echo "CookieAuthentication 1" | sudo tee -a /etc/tor/torrc >$dn 2>&1
    fi

if sudo grep "CookieAuthFileGroupReadable 1" /etc/tor/torrc | grep -v '^#' >$dn 2>&1 ; then true ; else
    echo "CookieAuthFileGroupReadable 1" | sudo tee -a /etc/tor/torrc >$dn 2>&1
    fi

if sudo grep "DataDirectoryGroupReadable 1" /etc/tor/torrc | grep -v '^#' >$dn 2>&1 ; then true ; else
    echo "DataDirectoryGroupReadable 1" | sudo tee -a /etc/tor/torrc >$dn 2>&1
    fi

}

function enable_tor_general_mac {
dir=/usr/local/etc/tor
file=$dir/torrc

if [[ ! -d $dir ]] ; then sudo mkdir -p $dir >$dn 2>&1 ; fi

if [[ ! -e $file ]] ; then 
touch $file >$dn 2>&1
cat << EOF | sudo tee -a $file >$dn
# Additions by Parmanode...
ControlPort 9051
CookieAuthentication 1
CookieAuthFileGroupReadable 1
DataDirectoryGroupReadable 1
EOF
return 0
fi

if [[ ! -d /usr/local/etc/tor ]] >$dn 2>&1 ; then return 1 ; fi

if ! sudo cat $file | grep -q "# Additions by Parmanode..." >$dn 2>&1 ; then
echo "# Additions by Parmanode..." | sudo tee -a $file >$dn 2>&1
fi

if sudo grep "ControlPort 9051" $file | grep -qv '^#' >$dn 2>&1 ; then true ; else
    echo "ControlPort 9051" | sudo tee -a $file >$dn 2>&1
    fi

if sudo grep "CookieAuthentication 1" $file | grep -qv '^#' >$dn 2>&1 ; then true ; else
    echo "CookieAuthentication 1" | sudo tee -a $file >$dn 2>&1
    fi

if sudo grep "CookieAuthFileGroupReadable 1" $file | grep -qv '^#' >$dn 2>&1 ; then true ; else
    echo "CookieAuthFileGroupReadable 1" | sudo tee -a $file >$dn 2>&1
    fi

if sudo grep "DataDirectoryGroupReadable 1" $file | grep -qv '^#' >$dn 2>&1 ; then true ; else
    echo "DataDirectoryGroupReadable 1" | sudo tee -a $file >$dn 2>&1
    fi

}