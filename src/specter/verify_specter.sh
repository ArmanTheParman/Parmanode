function verify_specter {

cd $HOME/parmanode/specter

gpg --keyserver keyserver.ubuntu.com --recv-keys 36ed357ab24b915f

if ! shasum -a 256 --ignore-missing --check SHA256SUMS ; then echo "Checksum failed. Aborting." ; enter_continue ; return 1 
   else
   set_terminal
   echo "gpg and sha256 checks passed"
   sleep 1.5
   set_terminal
   return 0
fi 
}