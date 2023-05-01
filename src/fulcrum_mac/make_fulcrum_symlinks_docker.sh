function make_fulcrum_symlinks_docker {

#On host

cd $HOME/parmanode/fulcrum/config
ln -s $HOME/parmanode/fulcrum/fulcrum.conf fulcrum.conf

#In Docker

docker exec -d -u parman fulcrum /bin/bash -c \
"ln -s /home/parman/parmanode/fulcrum/fulcrum.conf /home/parman/parmanode/fulcrum/config/fulcrum.conf"

}