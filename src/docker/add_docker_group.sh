function add_podman_group {

if [[ $OS == "Linux" ]] ; then true ; else return 1 ; fi

if which podman ; then true ; else return 1 ; fi

if grep podman /etc/group ; then true ; else return 1 ; fi

if id $(whoami) | grep podman ; then return 0 ; else 
    sudo usermod -aG podman $USER
    fi

return 0
}
