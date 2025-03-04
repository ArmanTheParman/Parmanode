function install_cargo {

announce "You may soon see a prompt to install Cargo. At that time, choose \"1\"" \
"to continue the installation"

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs/ | sh -s -- -y
source $HOME/.cargo/env #or restart shell
if ! cargo --version ; then announce "Installing cargo software failed. Aborting." ; return 1 ; fi
debug "install cargo function end"
}