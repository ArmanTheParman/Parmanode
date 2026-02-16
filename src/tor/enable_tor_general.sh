function enable_tor_general {

#exit if done before
if sudo grep -qEi "# Additions by Parmanode" $torrc >$dn 2>&1 ; then return 0 ; fi

#Match tor general additions in order, excluding heading (redundant)
if $xsudo grep -Pzq "ControlPort 9051\nCookieAuthentication 1\nCookieAuthFileGroupReadable 1\nDataDirectoryGroupReadable 1" $torrc >$dn 2>&1 ; then return 0 ; fi

#install tor if needed
if ! which tor >$dn 2>&1 ; then install_tor ; fi

#add debian-tor, doesn't hurt
[[ $OS == "Linux" ]] && sudo usermod -a -G debian-tor $USER >$dn 2>&1

#add control port
if [[ ! -e $torrc ]] || ! sudo grep -q "# Additions by Parmanode" $torrc ; then 
touch $torrc >$dn 2>&1
cat << EOF | sudo tee -a $torrc >$dn
# Additions by Parmanode...
ControlPort 9051
CookieAuthentication 1
CookieAuthFileGroupReadable 1
DataDirectoryGroupReadable 1
EOF
fi
}

function remove_tor_general {

$xsudo gsed -i "/# Additions by Parmanode/d" $torrc >$dn 2>&1
$xsudo gsed -i "/ControlPort 9051/d" $torrc >$dn 2>&1
$xsudo gsed -i "/CookieAuthentication 1/d" $torrc >$dn 2>&1
$xsudo gsed -i "/CookieAuthFileGroupReadable 1/d" $torrc >$dn 2>&1
$xsudo gsed -i "/DataDirectoryGroupReadable 1/d" $torrc >$dn 2>&1

}