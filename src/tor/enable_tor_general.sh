function enable_tor_general {
#install tor if needed
if ! which tor >$dn 2>&1 ; then install_tor ; fi

#add debian-tor, doesn't hurt
[[ $OS == "Linux" ]] && sudo usermod -a -G debian-tor $USER >$dn 2>&1

#add control port
! sudo test -f $torrc || sudo touch $torrc >$dn 2>&1

sudo gsed -i -E "/# Additions by Parmanode/d" $torrc >$dn 2>&1
sudo gsed -i -E "/^ControlPort 9051/d" $torrc >$dn 2>&1
sudo gsed -i -E "/^CookieAuthentication 1/d" $torrc >$dn 2>&1
sudo gsed -i -E "/^CookieAuthFileGroupReadable 1/d" $torrc >$dn 2>&1
sudo gsed -i -E "/^DataDirectoryGroupReadable 1/d" $torrc >$dn 2>&1

cat << EOF | sudo tee -a $torrc >$dn

# Additions by Parmanode...
ControlPort 9051
CookieAuthentication 1
CookieAuthFileGroupReadable 1
DataDirectoryGroupReadable 1

EOF
}