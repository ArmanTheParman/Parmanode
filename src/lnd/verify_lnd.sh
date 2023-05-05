function verify_lnd {
#import Roasbeef's public key
gpg --import $original_dir/src/lnd/roasbeef.pgp >/dev/null 2>&1

cd $HOME/parmanode
#verify SHA256 output list file.
if ! gpg verify *.sig manifest*.txt ; then
    set_terminal
    echo "GPG verification failed. Unknown reason. Please report to Parman. Aborting."
    enter_continue
    return 1
else
    set_terminal
    echo "GPG verification passed."
    sleep 2
fi
#Perform SHA256 to verify
if ! sha256sum --ignore-missing --check man*.txt ; then
set_terminal
echo "SHA256 check failed. Unknown reason. Please report to Parman. Aborting."
return 1
fi
}   