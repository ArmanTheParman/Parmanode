function uninstall_podman_mac {
while true ; do set_terminal ; echo -e "
########################################################################################
$cyan
                      Docker will be removed from your system
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) backtomain ;; y) break ;; n) return 1 ;; *) invalid ;;
esac
done

# Stop Docker Desktop and daemon
osascript -e 'quit app "Docker"'

# Stop all podman containers
podman stop $(podman ps -aq)

# Remove the Docker Desktop application
sudo rm -rf /Applications/Docker.app

# Remove Docker related files
sudo rm -rf ~/Library/Group\ Containers/group.com.podman

# Remove Docker settings
sudo rm -rf ~/Library/Containers/com.podman.podman
sudo rm -rf ~/Library/Application\ Support/Docker

# Remove Docker logs
sudo rm -rf ~/Library/Logs/Docker\ Desktop
sudo rm -rf ~/Library/Logs/com.podman.podman

# Remove Docker CLI and Kubernetes CLI (kubectl)
sudo rm -rf /usr/local/bin/podman /usr/local/bin/podman-compose /usr/local/bin/podman-credential-osxkeychain /usr/local/bin/podman-machine /usr/local/bin/podman-machine-driver-hyperkit /usr/local/bin/podman-machine-driver-vmware /usr/local/bin/podman-machine-driver-vmwarefusion /usr/local/bin/podman-machine-driver-xhyve /usr/local/bin/podman-machine-driver-virtualbox /usr/local/bin/hyperkit /usr/local/bin/kubectl /usr/local/bin/kubectl.podman /usr/local/bin/kompose /usr/local/bin/notary /usr/local/bin/vpnkit >$dn 2>&1

# Remove Docker VMs and images
sudo rm -rf ~/.podman
installed_conf_remove "podman-"
set_terminal
success "Docker" "being uninstalled."
}
