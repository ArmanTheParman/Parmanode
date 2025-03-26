function update_homebrew {
    brew update
    brew upgrade
    install_homebrew_packages
}

function install_homebrew_packages {
    $macprefix/bin/brew install bash
    $macprefix/bin/brew install netcat
    $macprefix/bin/brew install jq
    $macprefix/bin/brew install vim
    $macprefix/bin/brew install tmux
    $macprefix/bin/brew install tor
    $macprefix/bin/brew install gnu-sed
    $macprefix/bin/brew install gsed
}
