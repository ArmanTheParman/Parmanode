function update_homebrew {
    brew update
    brew upgrade
    install_homebrew_packages
}

function install_homebrew_packages {
    /opt/homebrew/bin/brew install bash
    /opt/homebrew/bin/brew install netcat
    /opt/homebrew/bin/brew install jq
    /opt/homebrew/bin/brew install vim
    /opt/homebrew/bin/brew install tmux
    /opt/homebrew/bin/brew install tor
    /opt/homebrew/bin/brew install gnu-sed
    /opt/homebrew/bin/brew install gsed
}
