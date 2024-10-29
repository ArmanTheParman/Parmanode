function install_bitcoin_docker {

yesorno "You are about to install Bitcoin into a docker container of your
    choice." || return 1

if [[ -z $1 ]] ; then

    while true ; do

        announce "Please type the name of the running Docker container you want to use."
        choice=$enter_cont

        case $choice in
        Q|q) exit ;; p|) return 1 ;; m|M) back2main ;;
        "")
        invalid ;;
        *)
        if docker ps 2>$1 | grep -q $choice ; then
        break
        else
        announce "This container is not running"
        fi
        ;;
        esac
        done

        yesorno "You have chosen the $choice container." && break 

    done

    export dockername=$choice 

else
    export dockername=${1}
fi

debug "dockername is $dockername"

cat << 'EOF' >/tmp/install_parmanode_docker.sh 
#!/bin/bash
cd $HOME/parman_programs/parmanode && git pull \
|| { 
    mkdir -q $HOME/parman_programs/
    cd $HOME/parman_programs
    git clone https://github.com/armantheparman/parmanode.git
   }
EOF
sudo chmod +x /tmp/install_parmanode_docker.sh
docker cp /tmp/install_parmanode_docker.sh $dockername:/tmp/install_parmanode_docker.sh >$dn 2>&1

}
