function docker_package_download_linux {

sudo apt-get update -y 
sudo apt-get install ca-certificates curl gnupg -y

sudo install -m 0755 -d /etc/apt/keyrings
. /etc/os-release #get ID
curl -fsSL https://download.docker.com/linux/$ID/gpg | sudo gpg --yes --dearmor -o /etc/apt/keyrings/docker.gpg

sudo chmod a+r /etc/apt/keyrings/docker.gpg
sudo apt-get update -y && export APT_UPDATE="true"

#modified instruction from official Docker guide to include Linuxmint conversion

get_linux_version_codename 
  
source /etc/os-release && debug "&& debug, ID is $ID after source os-release"

  #url ID value tweaking...
  if [[ $NAME == "LMDE" ]] ; then
      ID=debian #for docker url
      parmanode_conf_add "ID=debian"
  elif [[ $ID == "linuxmint" ]] ; then 
      debug "ID, 1.5, in linux mint. ID=$ID"
      ID=ubuntu
      parmanode_conf_add "ID=ubuntu"
  else
      ID=$ID
      parmanode_conf_add "ID=$ID"
  fi

debug "ID is $ID"

  echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$ID \
  "$(echo "$VCequivalent")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list >$dn 

#fix ubuntu label to debian if needed:
   debug "2nd, ID is $ID"
   if [[ $ID == "debian" ]] ; then 
       sudo sed -i 's/ubuntu/debian/g' /etc/apt/sources.list.d/docker.list >> $dp/sed.log 2>&1
   fi

sudo apt-get update -y && export APT_UPDATE="true"

installed_config_add "docker-start" 
counter=0 ; while [[ $counter -le 1 ]] ; do
sudo apt-get install containerd.io docker-ce docker-ce-cli docker-buildx-plugin docker-compose-plugin docker-compose -y 
exit_status=$?

while true ; do
    enter_continue "enter c to continue, or x to exit"
    case $choice in c) break ;; x) exit 1 ;; *) continue ;; esac
done

if [ $exit_status != 0 ] ; then
echo -e "\n\nAn error at this stage is sometimes fixed by repeating the command. 
Repeating in 10 seconds ...\n" 
sleep 10
counter=$((counter + 1 ))
continue
fi
break
done

if [ $exit_status != 0 ] ; then 
           echo -e "\n\n    That didn't seem to work properly. Would you like to wait 30 seconds,
           \r    who knows it might work (y) (n)?"
           read choice 
                if [[ $choice == "y" ]] ; then 
                      echo -e "\nWaiting ..."
                      sleep 30 ; echo -e " 30 .. 29 ......."
                      sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y \
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
export docker_package_install_fail=1 
return 1
} 


                fi
fi

sudo usermod -aG docker $USER 

}
