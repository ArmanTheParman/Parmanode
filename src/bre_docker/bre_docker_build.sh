function bre_docker_build {

if [[ $1 == test ]] ; then

docker build -t bre .
                    
#modify .evn file after it has been built

}                     
