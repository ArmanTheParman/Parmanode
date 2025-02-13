function install_qrencode {

    [[ $1 == silent ]] || { yesorno "QREncode lets you make QR codes from the command line.
    Parmnode at this stage does not provide a menu service for you, but it does use the
    program for various things, eg printing lightning network info.

    Install?" || return 1 ; }

    if [[ $OS == "Linux" ]] ; then

        if ! which qrencode >$dn 2>&1 ; then sudo apt-get install qrencode -y ; fi

    elif [[ $OS == "Mac" ]] ; then

        brew_check || { enter_continue "Parmanode can't install QREncode without Brew" ; return 1 ; }
        if ! which qrencode >$dn 2>&1 ; then brew install qrencode ; fi

    fi

    [[ $1 == silent ]] && return 0

    success "QREncode has been installed."
    return 0
}