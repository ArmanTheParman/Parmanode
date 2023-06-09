function add_docker_group {

if [[ $OS == "Linux" ]] ; then true ; else return 1 ; fi

if which docker ; then true ; else return 1 ; fi

if grep docker /etc/group ; then true ; else return 1 ; fi

if id $whoami | grep docker ; then return 0 ; else 
    sudo usermod -aG docker $USER
    fi

return 0
}