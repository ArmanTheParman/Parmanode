function check_installed_programs {

if [[ ! -f $ic ]] ; then return 0 ; fi

#gsed

if [[ $OS == "Linux" ]] ; then
    which gsed >/dev/null 2>&1 || announce "Parmanode cannot detect gsed which is necessary for proper
    functioning. Things aint gonna work right. Be warned."
elif [[ $OS == "Mac" ]] ; then
    which gsed >/dev/null 2>&1 || { 
    yesorno "Parmanode cannot detect gsed which is necessary for proper
    functioning. Install now via 'brew install gnu-sed' ?" && brew install gnu-sed
    sleep 1
    if ! which gsed >$dn ; then announce "Failed to detect gsed. Aborting." ; exit 1 ; fi
    }
fi

#nginx 

if ! sudo which nginx >$dn 2>&1 ; then
installed_config_remove "nginx-"
gsed -i '/nginx-/d' $ic
else
installed_config_add "nginx-end"
fi

#docker

if { [[ $(uname) == "Darwin" ]] && which docker >$dn       ; } ||
   { [[ $(uname) == "Linux"  ]] && which docker >$dn && id | grep -q docker ; } ; then
       if ! grep -q docker-end $ic ; then
          installed_config_add "docker-end" 
       fi
else 
          installed_config_remove "docker"
fi

#gpg
if [[ $OS == "Mac" ]] && gpg --version |& grep -qi "killed" ; then
    while true ; do
        if grep -q "gpg-broken-ignore=1" $hm ; then break ; fi
        announce "${red}Something is wrong with your gpg installation. Verifying software will fail
        \r    if this isn't fixed.$orange

        \r    Hit$cyan <enter>$orange to allow Parmanode to attempt to fix it, or$cyan yolo$orange to ignore and
        \r    try to fix it yourself. You can see it's broken by typing$blue gpg --version$orange at
        \r    the terminal prompt.

        \r    If you enter$cyan endthefed$orange, Parmanode will not do anything and this message will
        \r    be suppressed next time."
        
        case $choice in
        "") fix_gpg ; break ;;
        yolo) break ;;
        endthefed) echo "gpg-broken-ignore=1" >> $hm ; break ;;
        *) invalid ;;
        esac
    done
fi
}

function fix_gpg {
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