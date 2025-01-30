function see_local_devices {
announce "This will create a list of all connected device, navigate with the
    tradiational vim commands or arrows.$red q$orange to exit it."

case $enter_cont in q) return ;; esac

if [[ $OS == Linux ]] && ! which nmap >$dn ; then
    if ! yesorno "OK to install nmap?" && clear && sudo apt-get update -y && sudo apt-get install nmap -y ; then
    return 1
    fi
elif [[ $OS == "Mac" ]] ; then
    if ! yesorno "OK to install nmap?" && clear && brew install nmap ; then
    return1
    fi
fi

IP_prefix=$(echo $IP | cut -d \. -f 1-3)
clear
please_wait
sudo nmap -sn $IP_prefix/24 | less
}