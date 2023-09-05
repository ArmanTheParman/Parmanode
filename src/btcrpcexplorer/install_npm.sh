function install_npm {

sudo apt update -y && sudo apt install npm -y 

which npm >/dev/null 2>1 || set_terminal && echo "Npm didn't install it seems. Aborting." \
        && enter_continue && return 1

}