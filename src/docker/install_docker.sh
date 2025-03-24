function install_podman {

if [[ $OS == Linux ]] ; then install_podman_linux || return 1 ; fi
if [[ $OS == Mac ]]   ; then install_podman_mac || return 1 ; fi

}