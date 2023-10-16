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
set_terminal ; echo -e "
########################################################################################

    Do you want to install bare a bare bones ParmaBox (an Ubuntu Docker container) 
    without any configuration or menu options, that you'll manage yourself, use
    yourself and clean up yourself?

    This option is faster (Type$cyan boring$orange then$cyan <enter>$orange).

    Or, continue with the default ParmaBox with more features and configuration (Just
    hit$cyan <enter>$orange)?

########################################################################################
"
read choice ; set_terminal
case $choice in 
boring|Boring) local pbox=boring ;;
*)
set_termianl ; echo -e "
########################################################################################

    At some point during the install process, you will be asked for parman's password.

    The password is$cyan \"parmanode\"$orange.

########################################################################################
"
enter_continue

mkdir $HOME/parmanode/parmabox
;;
esac


installed_config_add "parmabox-start"

clear

case $choice in 
boring)
docker run -d --name parmabox ubuntu tail -f /dev/null
;;
*)
docker run -d --name parmabox \
           -v $HOME/parmanode/parmabox:/home/parman/parmanode/parmabox \
           -p 10000:10000 \
           -p 8399:8332 \
           -p 50051:50001 \
           -p 11111:11111 \
           ubuntu \
           tail -f /dev/null

docker exec -it parmabox bash \
            -c "apt update -y ; apt install -y vim nano ssh sudo \
                net-tools curl wget git procps gnupg tree htop ; \
                groupadd -r parman && useradd -m -g parman parman ; \
                chown -R parman:parman /home/parman ; \
                echo 'parman:parmanode' | chpasswd ; \
                usermod -aG sudo parman "

docker exec -it -u parman parmabox bash \
            -c "mkdir /home/parman/Desktop ; \
                curl https://parmanode.com/install.sh | sh" 
;;
esac

installed_config_add "parmabox-end"
success "Your Linux Docker ParmaBox" "being installed" 
if [[ $choice != boring ]] ; then
set_terminal ; echo -e "
########################################################################################

    The directory $HOME/parmanode/parmabox on your host machine is 
    mounted to the /mnt directory inside the text_box Linux container. If you move a 
    file there, it will be accessible in both locations. 

    The root user is available to use, and also the user parman, wth the password  $cyan
    \"parmanode\"$orange.

    The parmanode software is also available inside the container at:

    /home/parman/parman_programs/parmanode 

    - a little bit of ParmInception ;)

########################################################################################
"
enter_continue
fi
}