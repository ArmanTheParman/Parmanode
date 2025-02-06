function see_local_devices {
announce "This will create a list of all connected device, navigate with the
    tradiational vim commands or arrows.$red q$orange to exit it."

case $enter_cont in q) return ;; esac

if [[ $OS == Linux ]] && ! which nmap >$dn ; then
    if  yesorno "OK to install nmap?" ; then 
        clear && sudo apt-get update -y && sudo apt-get install nmap -y 
    else
        return 1
    fi
elif [[ $OS == "Mac" ]] && ! which nmap >$dn ; then
    if  yesorno "OK to install nmap?" ; then 
        clear && brew install nmap
    else
        return 1
    fi
fi

IP_prefix=$(echo $IP | cut -d \. -f 1-3)
set_terminal_high
please_wait
nmap -sn $IP_prefix/24 2>$dn > $dp/.IPs 
gsed -i 's/Nmap scan report for //' $dp/.IPs
gsed -i '/Starting Nmap/d' $dp/.IPs
gsed -i '/Nmap done/d' $dp/.IPs
gsed -i '/^1/i
' $dp/.IPs
less $dp/.IPs
}