function verify_bitcoin {
if [[ $verify == "skip" ]] ; then return 0 ; fi #skipverify argument set in parman_variables
if [[ $bitcoin_compile = "true" ]] ; then return 0 ; fi
if [[ $SKIPVERIFY == "true" ]] ; then return 0 ; fi

cd $HOME/parmanode/bitcoin
set_terminal 46 120
if grep -q "$bitcoin_choice=knots" $pc ; then
             
    curl -LO https://bitcoinknots.org/files/$knotsmajor/$knotsversion.knots$knotsdate/SHA256SUMS 
    curl -LO https://bitcoinknots.org/files/$knotsmajor/$knotsversion.knots$knotsdate/SHA256SUMS.asc
else
    curl -LO https://bitcoincore.org/bin/bitcoin-core-$version/SHA256SUMS 
    curl -LO https://bitcoincore.org/bin/bitcoin-core-$version/SHA256SUMS.asc 
fi

if ! which gpg >$dn  && [[ $OS == Mac ]] ; then install_gpg4mac ; fi

#ignore-missing option not available on shasum
if which sha256sum >$dn ; then
    debug "Using sha256sum"
    if ! sha256sum --ignore-missing --check SHA256SUMS 2>$dn | grep -q ": OK" || [[ $test == "true" ]] ; then 
    sww "${orange}Checksum failed. Aborting. Sometimes this happens for unexplainable reasons. 
    Try uninstalling the partial Bitcoin installation and try again. (Error code VBS256S)
    
    Below is the contents of $hp/bitcoin/ where the files should have been downloaded:$red
    
$(ls -lah $hp/bitcoin/ | gsed -n '4,$p' | awk '{print "    "$9" .........."$5}')$orange 

    Type ${red}yolo{$orange} to ignore and continue" ; case $enter_cont in yolo) true ;; *) return 1 ;; esac ; fi
else
    if ! shasum -a 256 --check SHA256SUMS >$dn | grep -q ": OK"  || [[ $test == "true" ]] ; then
    sww "${orange}Checksum failed. Aborting. Sometimes this happens for unexplainable reasons. 
    Try uninstalling the partial Bitcoin installation and try again. (Error code VBSS256)
    
    Below is the contents of $hp/bitcoin/ where the files should have been downloaded:$red

$(ls -lah $hp/bitcoin/ | gsed -n '4,$p' | awk '{print "    "$9" .........."$5}')$orange

    Type ${red}yolo{$orange} to ignore and continue" ; case $enter_cont in yolo) true ;; *) return 1 ;; esac ; fi
fi

sleep 3
echo -e "\nPlease wait a moment for gpg verification..."

#keys from : https://github.com/bitcoin-core/guix.sigs/tree/main/builder-keys
gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys 658E64021E5793C6C4E15E45C2E581F5B998F30E >$dn 2>&1
gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys 1A3E761F19D2CC7785C5502EA291A2C45D0C504A >$dn 2>&1
gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys E777299FC265DD04793070EB944D35F9AC3DB76A >$dn 2>&1
curl https://raw.githubusercontent.com/bitcoin-core/guix.sigs/main/builder-keys/laanwj.gpg | gpg --import >$dn 2>&1
curl https://raw.githubusercontent.com/bitcoin-core/guix.sigs/main/builder-keys/Emzy.gpg | gpg --import >$dn 2>&1

    if gpg --verify --status-fd 1 SHA256SUMS.asc 2>&1 | grep -iq GOOD
    then
        echo -e "\nGPG verification of the SHA256SUMS file$green passed$orange.\n"
        [[ $btcpayinstallsbitcoin == "true" ]] || enter_continue 5
    else 
        echo -e "\nGPG verification$red failed$orange. Aborting.\n" 
        enter_continue
        return 1 
    fi
}