function verify_bitcoin { debugf
if [[ $verify == "skip" ]] ; then return 0 ; fi #skipverify argument set in parman_variables
if [[ $bitcoin_compile = "true" ]] ; then return 0 ; fi
if [[ $SKIPVERIFY == "true" ]] ; then return 0 ; fi

p4socket "#install_bitcoin#Verifying"

cd $HOME/parmanode/bitcoin
set_terminal 46 120
debug "bitcoin_choice, $bitcoin_choice; bitcoin_combo, $bitcoin_combo"
if [[ $bip110 == "true" ]] ; then
        curl -fsLO https://raw.githubusercontent.com/dathonohm/guix.sigs/refs/heads/bip110/29.2.knots20251110%2Bbip110-v0.1rc1/luke-jr/all.SHA256SUMS 
        curl -fsLO https://raw.githubusercontent.com/dathonohm/guix.sigs/refs/heads/bip110/29.2.knots20251110%2Bbip110-v0.1rc1/luke-jr/all.SHA256SUMS.asc 
else

    if grep -q "bitcoin_choice=knots" $pc || [[ $bitcoin_choice == "knots" ]] ; then
        debug
        curl -fsLO https://bitcoinknots.org/files/$knotsmajor/$knotsversion.knots$knotsdate/SHA256SUMS 
        curl -fsLO https://bitcoinknots.org/files/$knotsmajor/$knotsversion.knots$knotsdate/SHA256SUMS.asc
    else
        debug
        curl -fsLO https://bitcoincore.org/bin/bitcoin-core-$version/SHA256SUMS 
        curl -fsLO https://bitcoincore.org/bin/bitcoin-core-$version/SHA256SUMS.asc 
    fi

fi

if ! which gpg >$dn  && [[ $OS == "Mac" ]] ; then install_gpg4mac ; fi

#ignore-missing option not available on shasum
if which sha256sum >$dn ; then
    debug "Using sha256sum"
    if ! sha256sum --check *SHA256SUMS 2>$dn | grep -q ": OK" ; then 
    debug
    sww "${orange}Checksum failed. Aborting. Sometimes this happens for unexplainable reasons. 
    Try uninstalling the partial Bitcoin installation and try again. (Error code VBS256S)
    
    Below is the contents of $hp/bitcoin/ where the files should have been downloaded:$red
    
$(ls -lah $hp/bitcoin/ | gsed -n '4,$p' | awk '{print "    "$9" .........."$5}')$orange 

    Type ${red}yolo${orange} to ignore and continue. If you do that...
        -- GPG will be checked next anyway.
        -- The SHA256SUMS file and corresponding signature will be left in
$cyan        $hp/bitcoin $orange
      \r    for you to manually check." "bitcoin_choice: $bitcoin_choice, 
                                         version: $version, 
                                         btcpay_combo: $btcpay_combo" ; case $enter_cont in yolo) true ;; *) return 1 ;; esac ; fi
else
    if ! shasum -a 256 --check *SHA256SUMS 2>$dn | grep -q ": OK" ; then
    debug
    sww "${orange}Checksum failed. Aborting. Sometimes this happens for unexplainable reasons. 
    Try uninstalling the partial Bitcoin installation and try again. (Error code VBSS256)
    
    Below is the contents of $hp/bitcoin/ where the files should have been downloaded:$red

$(ls -lah $hp/bitcoin/ | gsed -n '4,$p' | awk '{print "    "$9" .........."$5}')$orange

    Type ${red}yolo${orange} to ignore and continue. If you do that...
        -- GPG will be checked next anyway.
        -- The SHA256SUMS file and corresponding signature will be left in
$cyan        $hp/bitcoin $orange
       \r    for you to manually check." ; case $enter_cont in yolo) true ;; *) return 1 ;; esac ; fi
fi

[[ $parmaview != 1 ]] && sleep 3 && echo -e "\nPlease wait a moment for gpg verification..."

#keys from : https://github.com/bitcoin-core/guix.sigs/tree/main/builder-keys
gpg --list-keys 658E64021E5793C6C4E15E45C2E581F5B998F30E >$dn 2>&1 || 
    gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys 658E64021E5793C6C4E15E45C2E581F5B998F30E >$dn 2>&1
gpg --list-keys 1A3E761F19D2CC7785C5502EA291A2C45D0C504A >$dn 2>&1 || 
    gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys 1A3E761F19D2CC7785C5502EA291A2C45D0C504A >$dn 2>&1 || gpg --import $pp/parmanode/src/keys/LD.asc >$dn 2>&1
gpg --list-keys E777299FC265DD04793070EB944D35F9AC3DB76A >$dn 2>&1 || 
    gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys E777299FC265DD04793070EB944D35F9AC3DB76A >$dn 2>&1
gpg --list-keys 71A3B16735405025D447E8F274810B012346C9A6 >$dn 2>&1 || 
    curl https://raw.githubusercontent.com/bitcoin-core/guix.sigs/main/builder-keys/laanwj.gpg | gpg --import >$dn 2>&1
gpg --list-keys 9EDAFF80E080659604F4A76B2EBB056FD847F8A7 >$dn 2>&1 || 
    curl https://raw.githubusercontent.com/bitcoin-core/guix.sigs/main/builder-keys/Emzy.gpg | gpg --import >$dn 2>&1

    if gpg --verify --status-fd 1 *SHA256SUMS.asc 2>&1 | grep -iq GOOD
    then
        debug
        echo -e "\nGPG verification of the SHA256SUMS file$green passed$orange.\n"
        [[ $parmaview != 1 ]] && { [[ $btcpayinstallsbitcoin == "true" ]] || enter_continue 5 ; }
    else 
        debug 
        sww "GPG verification$red failed$orange. Aborting.\n
        \r    Type yolo to ignore and continue. If you do that, The SHA256SUMS file and corresponding 
        \r    signature will be left in$cyan $hp/bitcoin $orange
        \r    for you to manually check." 
        case $enter_cont in yolo) return 0 ;; *) return 1 ;; esac 
    fi

return 0 #necessary
}