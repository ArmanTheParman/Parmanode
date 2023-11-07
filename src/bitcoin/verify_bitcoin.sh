function verify_bitcoin {
cd $HOME/parmanode/bitcoin

# get Bitcoin Shasums
curl -LO https://bitcoincore.org/bin/bitcoin-core-25.0/SHA256SUMS 
curl -LO https://bitcoincore.org/bin/bitcoin-core-25.0/SHA256SUMS.asc 

if ! which gpg  && [[ $OS == Mac ]] ; then install_gpg_mac ; fi

#ignore-missing option not available on shasum
if ! shasum -a 256 --check SHA256SUMS | grep -q OK ; then debug "Checksum failed. Aborting." ; return 1 ; fi

sleep 3
echo ""
echo " Please wait a moment for gpg verification..."

#keys from : https://github.com/bitcoin-core/guix.sigs/tree/main/builder-keys
gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys E777299FC265DD04793070EB944D35F9AC3DB76A >/dev/null 2>&1
curl https://raw.githubusercontent.com/bitcoin-core/guix.sigs/main/builder-keys/laanwj.gpg | gpg --import >/dev/null 2>&1
curl https://raw.githubusercontent.com/bitcoin-core/guix.sigs/main/builder-keys/Emzy.gpg | gpg --import >/dev/null 2>&1

debug_user "pause here and report back."

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