function update_homebrew {
    brew update
    brew upgrade
    install_homebrew_packages
}

function install_homebrew_packages {
    #extract the path of brew, can be /opt/homebrew or /usr/local, but who knows what variations MacOS might
    #decide to add in the future. This captures the path dynamically. If none returned, set a default at least.
    export macprefix="$(brew --prefix 2>/dev/null)" 
    if [[ -z $macprefix ]] ; then export macprefix="/usr/local" ; fi
    $macprefix/bin/brew install bash
    $macprefix/bin/brew install netcat
    $macprefix/bin/brew install jq
    $macprefix/bin/brew install vim
    $macprefix/bin/brew install tmux
    $macprefix/bin/brew install tor
    $macprefix/bin/brew install gnu-sed
    $macprefix/bin/brew install gsed
}
