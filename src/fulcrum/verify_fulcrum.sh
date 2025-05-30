function verify_fulcrum {

cd $hp/fulcrum

shasum -a 256 --check Fulcrum*shasums.txt >$tmp/FulcrumSHA256 2>&1

if ! grep -q OK $tmp/FulcrumSHA256 ; then 

    announce "Checksum$red failed$orange. Aborting.

    Sometimes this happens for unexplainable reasons.  Try uninstalling the partial 
    Fulcrum installation and install again." 

    rm $tmp/FulcrumSHA256 >$dn 2>&1
    return 1 
fi

rm $tmp/FulcrumSHA256 >$dn 2>&1

echo '-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: SKS 1.1.5
Comment: Hostname: pgp.mit.edu

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
jdzE/g==
=PElt
-----END PGP PUBLIC KEY BLOCK-----' | gpg --import >$dn 2>&1 || 
{ announce "key import failed" ; return 1 ; }

if gpg --verify --status-fd 1 $HOME/parmanode/fulcrum/F*shasums.txt.asc $HOME/parmanode/fulcrum/F*shasums.txt 2>&1 | grep -qi "GOOD" 
    then 
        short_announce "${green}gpg verification passed.$orange" "5"
        return 0
    else
        announce "${red}gpg verification fail. Aborting.$orange" 
        return 1
    fi
}