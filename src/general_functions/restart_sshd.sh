function restart_sshd {
    if [[ $OS == "Linux" ]] ; then
    sudo systemctl restart sshd >$dn 2>&1
    elif [[ $OS == "Mac" ]] ; then
    sudo launchctl unload -w /System/Library/LaunchDaemons/ssh.plist >$dn 2>&1
    sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist >$dn 2>&1
    fi
}