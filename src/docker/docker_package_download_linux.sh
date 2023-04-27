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

installed_config_add "docker-start" 
counter=0 ; while [[ $counter -le 1 ]] ; do
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y 
exit_status=$?
if [ $exit_status != 0 ] ; then
echo "An error at this stage is sometimes fixed by repeating the command. Repeating in 3..2..1..."
sleep 3
counter=$((counter + 1 ))
continue
fi
break
done

log "docker" "exit status of apt-get install is $exit_status"
if [ $exit_status == 0 ] ; then true ; else announce "Docker install failed." && return 1 ; fi


sudo usermod -aG docker $USER $$ log "docker" "exit status of usermod is $?"

if id | grep docker ; then true ; else 
debug "failed to add docker group to $USER. Proceed with caution or do it yourself. \
if installing BTCPay server, then the rest of the intstallation will fail."
fi
}