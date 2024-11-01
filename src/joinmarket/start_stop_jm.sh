function start_joinmarket {

docker start joinmarket
start_socat joinmarket   
internal_docker_socat_jm 

}

function stop_joinmarket {
docker stop joinmarket
stop_socat joinmarket
}


function internal_docker_socat_jm  {
#For Macs, start socat inside container as well
    if [[ $OS == Mac ]] ; then
        counter=0
        while [[ $counter -lt 10 ]] ; do
            docker exec joinmarket ps >/dev/null && break
            sleep 1
            counter=$((counter + 1))
        done

        docker exec -d joinmarket socat TCP4-LISTEN:61000,reuseaddr,fork TCP:127.0.0.1:62601
        return
    fi
}