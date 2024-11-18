function uninstall_docker_linux {

while true ; do set_terminal ; echo -e "
########################################################################################
$cyan
                      Docker will be removed from your system
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose "epq" ; read choice
case $choice in q|Q|QUIT|Quit) exit 0 ;; p|P|n|N|no) return 1 ;; y) break ;; *) invalid ;; esac 
done

set_terminal ; echo "
Stopping all running containers...
"
docker stop $(docker ps -q) > /dev/null 2>&1

echo "Purging Docker programs..."
sleep 1
sudo apt-get purge docker docker-engine docker.io containerd runc docker-ce \
    docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
    docker-ce-rootless-extras -y

set_terminal
echo "
Removing all Docker containers, images, and volumes and configuration choices.
"
choose "qc" ; read choice ; case $choice in q|Q|Quit|QUIT|quit) return 1 ;; esac

sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd

log "docker" "uninstall; function finished"
installed_config_remove "docker"
success "Docker" "being uninstalled."
return 0
}