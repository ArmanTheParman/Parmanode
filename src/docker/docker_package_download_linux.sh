function podman_package_download_linux {

sudo apt-get update -y
sudo apt-get install ca-certificates curl gnupg -y

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.podman.com/linux/ubuntu/gpg | sudo gpg --yes --dearmor -o /etc/apt/keyrings/podman.gpg
sudo chmod a+r /etc/apt/keyrings/podman.gpg
sudo apt-get update -y

#modified instruction from official Docker guide to include Linuxmint conversion

get_linux_version_codename 
  
source /etc/os-release && debug "&& debug, ID is $ID after source os-release"

  #url ID value tweaking...
  if [[ $NAME == LMDE ]] ; then
      ID=debian #for podman url
      parmanode_conf_add "ID=debian"
  elif [[ $ID == linuxmint ]] ; then 
      debug "ID, 1.5, in linux mint. ID=$ID"
      ID=ubuntu
      parmanode_conf_add "ID=ubuntu"
  else
      ID=$ID
      parmanode_conf_add "ID=$ID"
  fi

debug "ID is $ID"

  echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/podman.gpg] https://download.podman.com/linux/$ID \
  "$(echo "$VCequivalent")" stable" | \
  sudo tee /etc/apt/sources.list.d/podman.list >$dn 

#fix ubuntu label to debian if needed:
   debug "2nd, ID is $ID"
   if [[ $ID == "debian" ]] ; then 
       sudo sed -i 's/ubuntu/debian/g' /etc/apt/sources.list.d/podman.list >> $dp/sed.log 2>&1
   fi

sudo apt-get update -y

installed_config_add "podman-start" 
counter=0 ; while [[ $counter -le 1 ]] ; do
sudo apt-get install containerd.io podman-ce podman-ce-cli podman-buildx-plugin podman-compose-plugin podman-compose -y 
exit_status=$?
if [ $exit_status != 0 ] ; then
echo -e "\n\nAn error at this stage is sometimes fixed by repeating the command. 
Repeating in 10 seconds ...\n" 
sleep 10
counter=$((counter + 1 ))
continue
fi
break
done

log "podman" "exit status of apt-get install is $exit_status"
if [ $exit_status != 0 ] ; then 
           echo -e "\n\n    That didn't seem to work properly. Would you like to wait 30 seconds,
           \r    who knows it might work (y) (n)?"
           read choice 
                if [[ $choice == "y" ]] ; then 
                      echo -e "\nWaiting ..."
                      sleep 30 ; echo -e " 30 .. 29 ......."
                      sudo apt-get install podman-ce podman-ce-cli containerd.io podman-buildx-plugin podman-compose-plugin -y \
                      || { echo -e "
########################################################################################                      

    Docker install failed. Sometimes it's because you are using a very new version
    of Linux, and Docker has not organised itself to have a package named after your
    new Linux version. It's fixable - please let Parman know, to get it
    done, OR, you can try to manually install Docker yourself - Parmanode will 
    detect that it's been updated.

########################################################################################
"
enter_continue && clear
export podman_package_install_fail=1 
return 1
} 


                fi
fi

sudo usermod -aG podman $USER && log "podman" "exit status of usermod is $?"

}
