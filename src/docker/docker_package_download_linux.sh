function docker_package_download_linux {

sudo apt-get update -y
sudo apt-get install ca-certificates curl gnupg -y

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --yes --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
sudo apt-get update -y

#modified instruction from official Docker guide to include Linuxmint conversion
  sudo source /etc/os-release
    if [[ $ID != "debian" ]] ; then parmanode_conf_add "ID=ubuntu" ; fi
  get_linux_version_codename 
    

  echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$ID \
  "$(echo "$VCequivalent")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#fix ubuntu label to debian if needed:
   source /etc/os-release
   if [[ $ID == "debian" ]] ; then 
       sudo sed -i 's/ubuntu/debian/g' /etc/apt/sources.list.d/docker.list >/dev/null 2>&1
   fi



sudo apt-get update -y

installed_config_add "docker-start" 
counter=0 ; while [[ $counter -le 1 ]] ; do
sudo apt-get install containerd.io docker-ce docker-ce-cli docker-buildx-plugin docker-compose-plugin docker-compose -y 
exit_status=$?
if [ $exit_status != 0 ] ; then
echo ""
echo ""
echo "An error at this stage is sometimes fixed by repeating "
echo "the command. Repeating in 10 seconds ..." 
sleep 10
counter=$((counter + 1 ))
continue
fi
break
done

log "docker" "exit status of apt-get install is $exit_status"
if [ $exit_status != 0 ] ; then 
           echo ""
           echo ""
           echo "That didn't seem to work properly. Would you like to wait 30 seconds," 
           echo "who knows it might work (y) (n)?"
           read choice 
                if [[ $choice == "y" ]] ; then 
                      echo ""
                      echo "Waiting ..."
                      sleep 30 ; echo " 30 .. 29 ......."
                      sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y \
                      || { echo -e "
########################################################################################                      

    Docker install failed. Sometimes it's because you are using a very New versino
    of Linux, and Docker has not organised itself to have a package named after your
    new Linux version. It's fixable - please let Parman know, to get it somethine
    done, OR, you can try to manually install Docker yourself - Parmanode will 
    detect that it's been updated.

########################################################################################
"
enter_continue && clear
export docker_package_install_fail=1 
return 1
} 


                fi
fi

sudo usermod -aG docker $USER && log "docker" "exit status of usermod is $?"

}