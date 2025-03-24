function uninstall_podman_linux {
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

set_terminal ; echo "
Stopping all running containers...
"
podman stop $(podman ps -q) >$dn 2>&1

echo "Purging Docker programs..."
sleep 1
sudo apt-get purge podman podman-engine podman.io containerd runc podman-ce \
    podman-ce-cli containerd.io podman-buildx-plugin podman-compose-plugin \
    podman-ce-rootless-extras -y

set_terminal
echo "
Removing all Docker containers, images, and volumes and configuration choices.
"
choose "qc" ; read choice ; case $choice in q|Q|Quit|QUIT|quit) return 1 ;; esac

sudo rm -rf /var/lib/podman
sudo rm -rf /var/lib/containerd

log "podman" "uninstall; function finished"
installed_config_remove "podman"
success "Docker" "being uninstalled."
return 0
}