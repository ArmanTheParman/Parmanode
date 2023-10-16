function install_parmabox {

if ! which docker > /dev/null ; then announce \
"Please install Docker from the Parmanode install menu first."
return 1
fi

if ! docker ps >/dev/null ; then announce \
"Please make sure Docker is running first."
return 1
fi

if docker ps | grep -q parmabox ; then announce
"The parmabox container is already running."
return 1
fi

mkdir $HOME/parmanode/parmabox
installed_config_add "parmabox-start"

docker run -d --name parmabox \
           -v $HOME/parmanode/parmabox:/home/parmanode/parmabox \
           -p 10000:10000 \
           -p 8399:8332 \
           -p 50051:50001 \
           -p 10000:10000 \
           ubuntu \
           tail -f /dev/null

docker exec -d parmabox bash \
            -c "apt update -y ; apt install vim nana ssh sudo 
                net-tools curl wget gnugpg git procps systemd ; \
                groupadd -r parman && useradd -m -g parman parman ; \
                chown -R parman:parman /home/parman ; \
                echo 'parman:parmanode' | chpasswd ; \
                usermod -aG sudo parman ; \
                curl https://parmanode.com/install.sh | sh ; \

"


installed_config_add "parmabox-end"
success "Your Linux Docker ParmaBox" "being installed" 

announce "The directory $HOME/parmanode/parmabox on your host machine is mounted 
to /mnt directory inside the text_box Linux container. If you move a file there, it 
will be accessible in both locations. 

The root user is available to use, and also the user parman, wth the password 
\"parmanode\".

The parmanode software is available inside the container at:

     /home/parman/parman_programs/parmanode 

- a little bit of ParmInception."
########################################################################################
}