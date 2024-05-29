function verify_litd {
#Victor Tigeström's pubkey
gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys 187F6ADD93AE3B0CF335AA6AB984570980684DCC

cd $HOME/parmanode/litd
debug "wait"
#verify SHA256 output list file.
if  ! gpg --verify --status-fd 1 *.sig *.txt 2>&1 | grep -q GOOD ; then
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
if which sha256sum >/dev/null ; then
    if ! sha256sum --ignore-missing --check *.txt ; then
    set_terminal
    echo "SHA256 check failed. Unknown reason. Please report to Parman. Aborting."
    enter_continue
    return 1
    fi
else
    if ! shasum -a 256 --check *.txt | grep OK ; then
    set_terminal
    echo "SHA256 check failed. Unknown reason. Please report to Parman. Aborting."
    enter_continue
    return 1
    fi
fi
}   