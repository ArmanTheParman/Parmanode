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

#podman - if this is installed, it hijacks docker commands and they fail.
if which podman >$dn 2>&1 && ! grep -q "podman-ignore=1" $hm ; then
    announce "${red}Podman detected. This program interferes with docker commands and must be uninstalled
    \r    for Parmanode to work properly. Please uninstall Podman yourself. If you decline to do this,
    \r    it is recommeneded you don't use apps that rely on docker, eg Mempool, Vaultwarden and others.
    
    \r    To dismiss this message forever, type$cyan endthefed$orange and hit <enter>."
    case $enter_cont in endthefed) echo "podman-ignore=1" >> $hm ;; esac
fi

}
