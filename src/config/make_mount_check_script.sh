# The systemd service file will run this script to make sure the drive is mounted if needed.
# Can't simply make a text file, because it's dynamically adjusted according to the directories
# in use
# Lots of backslashes as escape characters here so that the special characters are printed as is
# rather than being interpreted.

function make_mount_check_script {

echo "#!/bin/bash

source \$HOME/.parmanode/parmanode.conf 

if [[ \$drive == \"internal\" ]] ; then exit 0 ; fi

if [[ \$drive == \"external\" || \$drive_fulcrum == \"external\" ]] 
then
            counter=0

            while [[ \$counter -le 5 ]] ; do   #Checking if it's mounted, up to 5 times, 1 second each, then exit...

                mount_point=\"/media/$(whoami)/parmanode\"

                    if [ -n \"\$mount_point\" ] && mountpoint -q \"\$mount_point\" 
                    then 
                        exit 0 
                    else 
                        if mount | grep -q parmanode ; then log \"parmanode\" \"WARNING: mount check with label, not mount point.\" ; exit 0 ; fi
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

# Sets permission of the new file, mount_check.sh
sudo chown $(whoami):$(whoami) $HOME/.parmanode/mount_check.sh 
# Makes file executable
sudo chmod +x $HOME/.parmanode/mount_check.sh 
}
