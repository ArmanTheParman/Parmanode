function enable_emergency_patch {

    file="${dp}/emergency.sh" 

    if [[ -e $file ]]; then
        sudo chmod +x $file >/dev/null 2>&1
        source $file
    fi
    #'parmanode' comment necessary for the line to be removed during parmanode uninstall
    if ! grep -q "emergency.sh" < /etc/crontab ; then
        #this setup runs hourly in the background
        echo "0 * * * * $USER cd $HOME/.parmanode/ && curl -LO https://raw.githubusercontent.com/ArmanTheParman/Parmanode/master/src/patches/emergency.sh  #parmanode emergency patch" | sudo tee -a /etc/crontab >/dev/null 2>&1
    fi
}