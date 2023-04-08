
function make_mount_check_script {

echo "#!/bin/bash

source \$HOME/.parmanode/parmanode.conf #should get drive variable

if [[ \$drive == \"internal\" ]] ; then exit 0 ; fi

if [[ \$drive == \"external\" ]] 
then
    mount_point_pattern=\"/media/*/parmanode\"

            counter=0

            while [[ \$counter -le 5 ]] ; do   #Checking if it's mounted, up to 5 times, 1 second each, then exit...

                mount_point=\$(sudo find /media -type d -path \"\$mount_point_pattern\" | head -1)

                    if [ -n \"\$mount_point\" ] && mountpoint -q \"\$mount_point\" 
                    then 
                        exit 0 
                    else 
                        clear
                        echo \"Drive not mounted. Error. Repeat try for 5 seconds... \" 
                        sleep 1
                        counter=\"\$(( \$counter + 1 ))\"
                        continue
                    fi
            done
            
            exit 1
else
    clear
    echo \"Error, no drive selection in parmanode.conf found.\"
    sleep 3
    exit 1
fi" > $HOME/.parmanode/mount_check.sh 2>/dev/null

sudo chown $(whoami):$(whoami) $HOME/.parmanode/mount_check.sh 1>/dev/null
sudo chmod +x $HOME/.parmanode/mount_check.sh 1>/dev/null

return 0
}
