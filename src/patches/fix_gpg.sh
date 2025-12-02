function fix_gpg { debugf
#mac only
which brew >$dn 2>&1 || install_homebrew

if gpg --version |& grep -qi "killed" ; then
    count=0
    while [[ $count -lt 4 ]] ; do
        which gpg >$dn 2>&1 || break
        sudo rm -rf $(which gpg) >$dn 2>&1
        count=$((count + 1))
    done
    brew uninstall gnupg --ignore-dependencies --force >$dn 2>&1
else 
    return 0
fi

brew install gnupg
echo ; echo ; echo ; enter_continue
gpg --version |& grep -qi "killed" && sww "${red}Failed to fix gpg. Try to fix it yourself or contact Parman." && return 1
return 0
}