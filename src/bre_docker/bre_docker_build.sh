function bre_docker_build {
#can set #NOCACHE to "--no-cache" as an environment variable if preferred
#eg use the following command to start the program, and then install... 
#NOCACHE="--no-cache" rp 
cd $HOME/parman_programs/parmanode/src/bre_docker
docker build -t bre $NOCACHE .
}                     
