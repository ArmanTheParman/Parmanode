function Macs_need_docker {
if [[ -z $1 ]] ; then log=parmanodl ; fi

while true ; do

    if [[ $OS == Mac ]] ; then

        if ! which docker >/dev/null 2>&1 ; then  #need to install docker and make sure it's running
            download_docker_mac && export docker=downloaded
            log "$log" "download_docker_mac done"
        fi
        
        if ! which docker >/dev/null ; then return 1 ; fi

        #start docker if it is not running 
        if ! docker ps >/dev/null 2>&1 ; then start_docker_mac || return 1 ;  break ; else break ; fi
    fi

break
done
}