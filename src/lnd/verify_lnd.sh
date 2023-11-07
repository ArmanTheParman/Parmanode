function verify_lnd {
#import Roasbeef's public key
gpg --import $original_dir/src/lnd/roasbeef.pgp 2>&1

cd $HOME/parmanode/lnd
debug "wait"
#verify SHA256 output list file.
if  ! gpg --verify --status-fd 1 *.sig manifest*.txt 2>&1 | grep -q GOOD ; then
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
if ! shasum -a 256  --check man*.txt ; then
set_terminal
echo "SHA256 check failed. Unknown reason. Please report to Parman. Aborting."
enter_continue
return 1
fi
}   