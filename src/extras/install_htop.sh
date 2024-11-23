function install_htop {

    if ! which htop ; then sudo apt-get install htop -y >$dn 2>&1 ; fi

    success "HTOP has been installed"
    
    return 0

}