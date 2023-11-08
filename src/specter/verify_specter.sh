function verify_specter {

cd $HOME/parmanode/specter

gpg --keyserver keyserver.ubuntu.com --recv-keys 36ed357ab24b915f

if which sha256sum >/dev/null ; then 
    if ! sha256sum --ignore-missing --check SHA256SUMS ; then echo "Checksum failed. Aborting." ; enter_continue ; return 1 ; fi
else
    if ! shasum --check SHA256SUMS | grep -q OK ; then echo "Checksum failed. Aborting." ; enter_continue ; return 1 ; fi
fi 
   
set_terminal
echo "gpg and sha256 checks passed"
sleep 1.5
set_terminal
return 0
}