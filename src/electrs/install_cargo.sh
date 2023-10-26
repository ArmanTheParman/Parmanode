function install_cargo {

announce "You may soon see a prompt to install Cargo. Choose \"1\" to continue" \
"the installation"

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs/ | sh 
source $HOME/.cargo/env #or restart shell
if ! cargo --version ; then announce "Installing cargo software failed. Aborting." ; return 1 ; fi
debug "install cargo function end"
}