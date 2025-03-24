function bre_podman_build {
#can set #NOCACHE to "--no-cache" as an environment variable if preferred
#eg use the following command to start the program, and then install... 
#NOCACHE="--no-cache" rp 
clear
cd $HOME/parman_programs/parmanode/src/bre_podman
podman build -t bre $NOCACHE .
}                     
