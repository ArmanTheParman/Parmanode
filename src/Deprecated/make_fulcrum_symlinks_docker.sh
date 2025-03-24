#deprecated

function make_fulcrum_symlinks_podman {

#On host

cd $HOME/parmanode/fulcrum/ && ln -s ./config/fulcrum.conf fulcrum.conf

#In Docker

podman exec -d -u parman fulcrum /bin/bash -c \
"cd /home/parman/parmanode/fulcrum/ && ln -s ./config/fulcrum.conf fulcrum.conf"

}
