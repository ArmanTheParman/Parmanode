function make_fulcrum_symlinks_docker {

#On host

cd $HOME/parmanode/fulcrum/config/
ln -s ../fulcrum.conf fulcrum.conf

#In Docker

docker exec -d -u parman fulcrum /bin/bash -c \
"cd /home/parman/parmanode/fulcrum/config/ && ln -s ../fulcrum.conf fulcrum.conf"

}
