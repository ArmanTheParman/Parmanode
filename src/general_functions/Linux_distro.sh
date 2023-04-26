function Linux_distro {
    
if [[ $OS == "Linux" ; ]] ; then

    if [ -f /etc/debian_version ]; then
    parmanode_conf_add "Linux=Debian"

    elif [ -f /etc/lsb-release ]; then
    parmanode_conf_add "Linux=Ubuntu"

    else
    parmanod_conf_add "Linux=Unknown"

    fi

else
    return 1
fi

return 0
}