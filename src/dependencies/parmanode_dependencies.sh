function parmanode_dependencies {
[[ $OS == "Mac" ]] && return 1
#If more programs are added here, version of the flag should increment

[[ $btcpay_combo == "true" || $btcpayinstallsbitcoin="true" || $btcdockerchoice == "yes" ]] && return 0

grep -q "dependency_check1=passed" $pc && return 0
export ask=false #if no block switches this on to true, then next time, the entire function can be skipped

    which jq >$dn || sudo grep -q "dont_install_jq" $dp/.dont_install || {
    export ask=true

        announce "Parmanode needs to install jq to continue. 
        $green 
        \r$green            y)$orange          OK, do it

        \r$red            n)$orange          Nah, ask me later

        \r$red            nooo)$orange       Nah, never ask again
    "
        case $enter_cont in
            y) [[ $APT_UPDATE == "true" ]] || { sudo apt-get update -y && export APT_UPDATE="true" ; }
                sudo apt-get install jq -y
                ;;
            nooo) echo "dont_install_jq" | tee -a $dp/.dont_install >$dn 2>&1 ;;
            esac
    }
    which tmux >$dn || sudo grep -q "dont_install_tmux" $dp/.dont_install || {
    export ask=true

        announce "Parmanode needs to install Tmux to continue. 
        $green 
        \r$green            y)$orange          OK, do it

        \r$red            n)$orange          Nah, ask me later

        \r$red            nooo)$orange       Nah, never ask again
    "
        case $enter_cont in
            y) [[ $APT_UPDATE == "true" ]] || { sudo apt-get update -y && export APT_UPDATE="true" ; }
                sudo apt-get install tmux -y
                ;;
            nooo) echo "dont_install_tmux" | tee -a $dp/.dont_install >$dn 2>&1 ;;
            esac
    }
    which gpg >$dn || sudo grep -q "dont_install_gpg" $dp/.dont_install || {
    export ask=true

        announce "Parmanode needs to install gpg to continue. 
        $green 
        \r$green            y)$orange          OK, do it

        \r$red            n)$orange          Nah, ask me later

        \r$red            nooo)$orange       Nah, never ask again
    "
        case $enter_cont in
            y) [[ $APT_UPDATE == "true" ]] || { sudo apt-get update -y && export APT_UPDATE="true" ; }
                sudo apt-get install gpg -y
                ;;
            nooo) echo "dont_install_gpg" | tee -a $dp/.dont_install >$dn 2>&1 ;;
            esac
    }
  
    which unzip >$dn || sudo grep -q "dont_install_unzip" $dp/.dont_install || {
    export ask=true

        announce "Parmanode needs to install unzip to continue. 
        $green 
        \r$green            y)$orange          OK, do it

        \r$red            n)$orange          Nah, ask me later

        \r$red            nooo)$orange       Nah, never ask again
    "
        case $enter_cont in
            y) [[ $APT_UPDATE == "true" ]] || { sudo apt-get update -y && export APT_UPDATE="true" ; }
                sudo apt-get install unzip -y
                ;;
            nooo) echo "dont_install_unzip" | tee -a $dp/.dont_install >$dn 2>&1  ;;
            esac
    }    

    which ssh >$dn || sudo grep -q "dont_install_ssh" $dp/.dont_install || {
    export ask=true

        announce "Parmanode wants to install ssh to continue. 
        $green 
        \r$green            y)$orange          OK, do it

        \r$red            n)$orange          Nah, ask me later

        \r$red            nooo)$orange       Nah, never ask again
    "
        case $enter_cont in
            y) [[ $APT_UPDATE == "true" ]] || { sudo apt-get update -y && export APT_UPDATE="true" ; }
                sudo apt-get install ssh -y
                sudo systemctl status ssh >$dn 2>&1 || sudo systemctl start ssh >$dn 2>&1
                ;;
            nooo) echo "dont_install_ssh" | tee -a $dp/.dont_install >$dn 2>&1 ;;
            esac
    }    
    which tor >$dn || sudo grep -q "dont_install_tor" $dp/.dont_install || {
    export ask=true

        announce "Parmanode needs to install tor to continue. 
        $green 
        \r$green            y)$orange          OK, do it

        \r$red            n)$orange          Nah, ask me later

        \r$red            nooo)$orange       Nah, never ask again
    "
        case $enter_cont in
            y) [[ $APT_UPDATE == "true" ]] || { sudo apt-get update -y && export APT_UPDATE="true" ; }
                sudo apt-get install tor -y
                ;;
            nooo) echo "dont_install_tor" | tee -a $dp/.dont_install >$dn 2>&1 ;;
            esac
    }    
        which nc >$dn || if ! sudo grep -q "dont_install_netcat" $dp/.dont_install ; then
    export ask=true

    announce "Parmanode needs to install netcat-tradiational to continue.
        $green 
        \r$green            y)$orange          OK, do it

        \r$red            n)$orange          Nah, ask me later

        \r$red            nooo)$orange       Nah, never ask again (some things won't work)
    "
    case $enter_cont in
            y) [[ $APT_UPDATE == "true" ]] || { sudo apt-get update -y && export APT_UPDATE="true" ; }
                sudo apt-get install netcat-traditional -y
                ;;
            nooo) echo "dont_install_netcat" | tee -a $dp/.dont_install >$dn 2>&1 ;;
       
    esac
fi

    which netstat >$dn || if ! sudo grep -q "dont_install_netstat" $dp/.dont_install ; then
    export ask=true

    announce "Parmanode needs to install net-tools to continue.
        $green 
        \r$green            y)$orange          OK, do it

        \r$red            n)$orange          Nah, ask me later

        \r$red            nooo)$orange       Nah, never ask again (some things won't work)
    "
    case $enter_cont in
            y) [[ $APT_UPDATE == "true" ]] || { sudo apt-get update -y && export APT_UPDATE="true" ; }
                sudo apt-get install net-tools -y
                ;;
            nooo) echo "dont_install_net-tools" | tee -a $dp/.dont_install >$dn 2>&1 ;;
    
    esac
fi 
    sudo which tune2fs >$dn || if ! sudo grep -q "dont_install_tune2fs" $dp/.dont_install ; then
    export ask=true

    announce "Parmanode wants to install tune2fs/e2fprogs to continue.
        $green 
        \r$green            y)$orange          OK, do it

        \r$red            n)$orange          Nah, ask me later

        \r$red            nooo)$orange       Nah, never ask again 
    "
    case $enter_cont in
            y) [[ $APT_UPDATE == "true" ]] || { sudo apt-get update -y && export APT_UPDATE="true" ; }
                sudo apt-get install e2fsprogs -y
                ;;
            nooo) echo "dont_install_tune2fs" | tee -a $dp/.dont_install >$dn 2>&1 ;;
 
    esac
fi
if ! dpkg -l | grep -q libfuse && ! sudo grep -q "dont_install_libfuse" $dp/.dont_install ; then
[[ $APT_UPDATE == "true" ]] || { sudo apt-get update -y && export APT_UPDATE="true" ; }

    announce "Parmanode needs to install libfuse to continue.
        $green 
        \r$green            y)$orange          OK, do it

        \r$red            n)$orange          Nah, ask me later

        \r$red            nooo)$orange       Nah, never ask again (some things won't work)
    "
    case $enter_cont in
            y) [[ $APT_UPDATE == "true" ]] || { sudo apt-get update -y && export APT_UPDATE="true" ; }
                sudo apt-get install -y fuse3
                sudo apt-get install -y libfuse2 libfuse3-3
                sudo apt-get install -y libfuse3-3
                ;;
            nooo) echo "dont_install_libfuse" | tee -a $dp/.dont_install >$dn 2>&1 ;;
      
    esac
fi   

### optional ... 
    unset install_array
    declare -a install_array
    sudo which ufw >$dn || install_array+=(ufw)
    dpkg -l | grep -q mdadm >$dn 2>&1 || install_array+=(mdadm)
    sudo which gparted >$dn 2>&1 || install_array+=(gparted)
    sudo which notify-send >$dn 2>&1 || install_array+=(notify-send)
    sudo which autossh >$dn 2>&1 || install_array+=(autossh)
    sudo which vim >$dn 2>&1 || install_array+=(vim)

if [[ -n $install_array ]] && ! grep -q "optional_install_none=1" $hm ; then
while true ; do
clear ; echo -e "
########################################################################################

    Parmanode detected the following$green OPTIONAL$orange programs are note installed.

    "
for x in ${install_array[@]} ; do echo -e "$cyan       $x\n" ; done
echo -e "$orange
    You have options...

$cyan              a)$orange       Install all
$cyan              s)$orange       Selectively install some (next window) 
$cyan              n)$orange       Install none for now
$cyan              nn)$orange      Install none and don't ask about these again


########################################################################################
"
choose xq
read choice ; clear
case $choice in
q) exit 1 ;; 
a) all="true" ; break ;;
s) break ;;
n) return 0 ;;
nn) echo "optional_install_none=1" | tee -a $hm ; return 0 ;;
*) invalid ;;
esac
done
fi



    sudo which ufw >$dn || sudo grep -q "dont_install_ufw" $dp/.dont_install || {
    export ask=true
    [[ $all == "true" ]] || announce "Parmanode wants to install ufw to continue. 
        $green 
        \r$green            y)$orange          OK, do it

        \r$red            n)$orange          Nah, ask me later

        \r$red            nooo)$orange       Nah, never ask again
    "
        [[ $all == "true" ]] && enter_cont=y
        case $enter_cont in
            y) [[ $APT_UPDATE == "true" ]] || { sudo apt-get update -y && export APT_UPDATE="true" ; }
                sudo apt-get install ufw -y
                ;;
            nooo) echo "dont_install_ufw" | tee -a $dp/.dont_install >$dn 2>&1 ;;
            esac
    }    
    dpkg -l | grep -q mdadm >$dn 2>&1 || sudo grep -q "dont_install_mdadm" $dp/.dont_install || {
    export ask=true

 [[ $all == "true" ]]  ||   announce "Parmanode wants to install mdadm to continue. 
        $green 
        \r$green            y)$orange          OK, do it

        \r$red            n)$orange          Nah, ask me later

        \r$red            nooo)$orange       Nah, never ask again
    "
        [[ $all == "true" ]] && enter_cont=y
        case $enter_cont in
            y) [[ $APT_UPDATE == "true" ]] || { sudo apt-get update -y && export APT_UPDATE="true" ; }
                sudo apt-get install mdadm -y
                ;;
            nooo) echo "dont_install_mdadm" | tee -a $dp/.dont_install >$dn 2>&1 ;;
            esac
    }    
    sudo which gparted >$dn || sudo grep -q "dont_install_gparted" $dp/.dont_install || {
    export ask=true

 [[ $all == "true" ]]   ||    announce "Parmanode wants to install gparted to continue. 
        $green 
        \r$green            y)$orange          OK, do it

        \r$red            n)$orange          Nah, ask me later

        \r$red            nooo)$orange       Nah, never ask again
    "
        [[ $all == "true" ]] && enter_cont=y
        case $enter_cont in
            y) [[ $APT_UPDATE == "true" ]] || { sudo apt-get update -y && export APT_UPDATE="true" ; }
                sudo apt-get install gparted -y
                ;;
            nooo) echo "dont_install_gparted" | tee -a $dp/.dont_install >$dn 2>&1 ;;
            esac
    }
  
    which notify-send >$dn || if ! sudo grep -q "dont_install_notify-send" $dp/.dont_install ; then
    export ask=true

 [[ $all == "true" ]]   || announce "Parmanode wants to install notify-send to continue.
        $green 
        \r$green            y)$orange          OK, do it

        \r$red            n)$orange          Nah, ask me later

        \r$red            nooo)$orange       Nah, never ask again (not needed as a server only) 
    "
        [[ $all == "true" ]] && enter_cont=y
    case $enter_cont in
            y) [[ $APT_UPDATE == "true" ]] || { sudo apt-get update -y && export APT_UPDATE="true" ; }
                sudo apt-get install libnotify-bin -y
                ;;
            nooo) echo "dont_install_notify-send" | tee -a $dp/.dont_install >$dn 2>&1 ;;
    
    esac
fi 
 
    sudo which autossh >$dn || if ! sudo grep -q "dont_install_autossh_v2" $dp/.dont_install ; then
    export ask=true

 [[ $all == "true" ]] ||  announce "Parmanode wants to install autossh to continue. This is very options, but useful
    for setting up reverse proxies.
        $green 
        \r$green            y)$orange          OK, do it

        \r$red            n)$orange          Nah, ask me later

        \r$red            nooo)$orange       Nah, never ask again 
    "
        [[ $all == "true" ]] && enter_cont=y
    case $enter_cont in
            y) [[ $APT_UPDATE == "true" ]] || { sudo apt-get update -y && export APT_UPDATE="true" ; }
                sudo apt-get install autossh -y
                ;;
            nooo) echo "dont_install_autossh_v2" | tee -a $dp/.dont_install >$dn 2>&1 ;;
 
    esac
fi 

    which vim >$dn || sudo grep -q "dont_install_vim" $dp/.dont_install || {
    export ask=true

 [[ $all == "true" ]]   ||    announce "Parmanode wants to install vim to continue. 
        $green 
        \r$green            y)$orange          OK, do it

        \r$red            n)$orange          Nah, ask me later

        \r$red            nooo)$orange       Nah, never ask again
    "
        [[ $all == "true" ]] && enter_cont=y
        case $enter_cont in
            y) [[ $APT_UPDATE == "true" ]] || { sudo apt-get update -y && export APT_UPDATE="true" ; }
                sudo apt-get install vim -y
                ;;
            nooo) echo "dont_install_vim" | tee -a $dp/.dont_install >$dn 2>&1 ;;
            *) continue ;;
            esac
    }  
[[ $ask == "false" ]] && parmanode_conf_add "dependency_check1=passed" 
rm $tmp/updateonce 2>$dn
debug "end of dependency check"
}