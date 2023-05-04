function verify_lnd {

gpg --import $original_dir/src/lnd/roasbeef.pgp >/dev/null 2>&1

cd $HOME/parmanode

if ! gpg verify *.sig manifest*.txt ; then
    set_terminal
    echo "GPG verification fail. Unknown reason. Please report to Parman. Aborting."
    enter_continue
    return 1
else
    set_terminal
    echo "GPG verification passed."
    sleep 2
fi


}   