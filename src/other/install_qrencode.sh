function install_qrencode {

    if [[ $OS == "Linux" ]] ; then

        if ! which qrencode >$dn 2>&1 ; then sudo apt-get install qrencode -y ; fi

    else

        if ! which qrencode >$dn 2>&1 ; then brew install qrencode ; fi

    fi

    return 0
}