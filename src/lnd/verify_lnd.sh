function verify_lnd {
#import Roasbeef's public key
gpg --import $pn/src/lnd/roasbeef.pgp || enter_continue "Failed to import Roasbeef's public key. Please report to Parman."


cd $HOME/parmanode/lnd
debug "wait"
#verify SHA256 output list file.

if [[ $lndversion="v0.18.5-beta" ]] || #this version provides corrupt signature files, goint to the hash file instead.
    if  ! gpg --verify --status-fd 1 *.sig manifest*.txt 2>&1 | grep -qi GOOD ; then
        set_terminal
        echo "GPG verification failed. Unknown reason. Please report to Parman. Aborting."
        enter_continue
        return 1
    else
        set_terminal
        echo -e "GPG verification$green passed$orange."
        sleep 2
    fi

#Perform SHA256 to verify
if which sha256sum >$dn ; then
    if ! sha256sum --ignore-missing --check man*.txt ; then
    set_terminal
    echo "SHA256 check failed. Unknown reason. Please report to Parman. Aborting."
    enter_continue
    return 1
    fi
else
    if ! shasum -a 256 --check man*.txt | grep OK ; then
    set_terminal
    echo "SHA256 check failed. Unknown reason. Please report to Parman. Aborting."
    enter_continue
    return 1
    fi
fi



}   