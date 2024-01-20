function verify_bitcoin {
if [[ $verify == skip ]] ; then return 0 ; fi #skipverify argument set in parman_variables

cd $HOME/parmanode/bitcoin

# get Bitcoin Shasums
curl -LO https://bitcoincore.org/bin/bitcoin-core-25.0/SHA256SUMS 
curl -LO https://bitcoincore.org/bin/bitcoin-core-25.0/SHA256SUMS.asc 

if ! which gpg >/dev/null  && [[ $OS == Mac ]] ; then install_gpg4mac ; fi

#ignore-missing option not available on shasum
if which sha256sum >/dev/null ; then
    if ! sha256sum --ignore-missing --check SHA256SUMS ; then announce "Checksum failed. Aborting." \
    "Sometimes this happens for unexplainable reasons. 
    Try uninstalling the partial Bitcoin installation and try again." ; return 1 ; fi
else
    rm /tmp/bitcoinsha256 >/dev/null 2>&1
    shasum -a 256 --check SHA256SUMS >/tmp/bitcoinsha256 2>&1
    if ! grep -q OK < /tmp/bitcoinsha256 ; then announce "Checksum failed. Aborting." \
    "Sometimes this happens for unexplainable reasons. 
    Try uninstalling the partial Bitcoin installation and try again." ; return 1 ; fi
    rm /tmp/bitcoinsha256 >/dev/null 2>&1
fi

sleep 3
echo ""
echo " Please wait a moment for gpg verification..."

#keys from : https://github.com/bitcoin-core/guix.sigs/tree/main/builder-keys
gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys E777299FC265DD04793070EB944D35F9AC3DB76A >/dev/null 2>&1
curl https://raw.githubusercontent.com/bitcoin-core/guix.sigs/main/builder-keys/laanwj.gpg | gpg --import >/dev/null 2>&1
curl https://raw.githubusercontent.com/bitcoin-core/guix.sigs/main/builder-keys/Emzy.gpg | gpg --import >/dev/null 2>&1

    if gpg --verify --status-fd 1 SHA256SUMS.asc 2>&1 | grep -q GOOD
    then
        echo ""
        echo "GPG verification of the SHA256SUMS file passed. "
        echo ""
        enter_continue
    else 
        echo ""
        echo "GPG verification failed. Aborting." 
        enter_continue
        return 1 
    fi
}