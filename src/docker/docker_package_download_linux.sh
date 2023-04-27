function docker_package_download_linux {

sudo apt-get update -y
sudo apt-get install ca-certificates curl gnupg -y

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
sudo apt-get update -y

#modified instruction from official Docker guide to include Linuxmint conversion
get_linux_version_codename && echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(echo "$VCequivalent")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y \

enter_continue 
installed_config_add "docker-start" 

#log "docker" "docker install failed" && announce "Docker install failed" && return 1

sudo usermod -aG docker $USER || log "docker" "failed to add docker group to $USER" && \
debug "failed to add docker group to $USER. Proceed with caution or do it yourself."
}