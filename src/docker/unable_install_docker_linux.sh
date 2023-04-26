function unable_install_docker_linux {
set_terminal_wider ; echo "
###########################################################################################################

    Parmanode was unable to match your OS to an available Docker installation (could be wrong). Please 
    manually install Docker yourself, then come back to Parmanode and skip over Docker installation.

    Instructions to install yourself, are here:

                https://docs.docker.com/engine/install/ubuntu/#install-from-a-package

###########################################################################################################
"
enter_continue ; set_terminal ; return 1 
}
