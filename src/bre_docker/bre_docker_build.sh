function bre_docker_build {
if [[ $debug == 3 ]] ; then
cd $HOME/parman_programs/parmanode/src/bre_docker
docker build -t bre --no-cache .
return 0
fi

cd $HOME/parman_programs/parmanode/src/bre_docker
docker build -t bre .
}                     
