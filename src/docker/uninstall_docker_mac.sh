function untinstall_docker_mac {

# Stop Docker Desktop and daemon
osascript -e 'quit app "Docker"'

# Stop all docker containers
docker stop $(docker ps -aq)

# Remove the Docker Desktop application
sudo rm -rf /Applications/Docker.app

# Remove Docker related files
sudo rm -rf ~/Library/Group\ Containers/group.com.docker

# Remove Docker settings
sudo rm -rf ~/Library/Containers/com.docker.docker
sudo rm -rf ~/Library/Application\ Support/Docker

# Remove Docker logs
sudo rm -rf ~/Library/Logs/Docker\ Desktop
sudo rm -rf ~/Library/Logs/com.docker.docker

# Remove Docker CLI and Kubernetes CLI (kubectl)
sudo rm -rf /usr/local/bin/docker /usr/local/bin/docker-compose /usr/local/bin/docker-credential-osxkeychain /usr/local/bin/docker-machine /usr/local/bin/docker-machine-driver-hyperkit /usr/local/bin/docker-machine-driver-vmware /usr/local/bin/docker-machine-driver-vmwarefusion /usr/local/bin/docker-machine-driver-xhyve /usr/local/bin/docker-machine-driver-virtualbox /usr/local/bin/hyperkit /usr/local/bin/kubectl /usr/local/bin/kubectl.docker /usr/local/bin/kompose /usr/local/bin/notary /usr/local/bin/vpnkit >/dev/null 2>&1

# Remove Docker VMs and images
sudo rm -rf ~/.docker

set_terminal
success "Docker" "being uninstalled."
}
