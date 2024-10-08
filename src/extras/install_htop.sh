function install_htop {

    if ! which htop ; then sudo apt-get install htop -y >/dev/null 2>&1 ; fi

    success "HTOP has been installed"
    
    return 0

}