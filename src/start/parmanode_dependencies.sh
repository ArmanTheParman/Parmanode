function parmanode_dependencies {
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
            nooo) echo "dont_install_jq" | tee $dp/.dont_install >$dn 2>&1 ;;
            esac
    }

    which vim >$dn || sudo grep -q "dont_install_vim" $dp/.dont_install || {
    export ask=true

        announce "Parmanode wants to install vim to continue. 
        $green 
        \r$green            y)$orange          OK, do it

        \r$red            n)$orange          Nah, ask me later

        \r$red            nooo)$orange       Nah, never ask again
    "
        case $enter_cont in
            y) [[ $APT_UPDATE == "true" ]] || { sudo apt-get update -y && export APT_UPDATE="true" ; }
                sudo apt-get install vim -y
                ;;
            nooo) echo "dont_install_vim" | tee $dp/.dont_install >$dn 2>&1 ;;
            *) continue ;;
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
            nooo) echo "dont_install_unzip" | tee $dp/.dont_install >$dn 2>&1  ;;
            esac
    }    
    which tmux >$dn || sudo grep -q "dont_install_tmux" $dp/.dont_install || {
    export ask=true


        announce "Parmanode needs to install tmux to continue. 
        $green 
        \r$green            y)$orange          OK, do it

        \r$red            n)$orange          Nah, ask me later

        \r$red            nooo)$orange       Nah, never ask again
    "
        case $enter_cont in
            y) [[ $APT_UPDATE == "true" ]] || { sudo apt-get update -y && export APT_UPDATE="true" ; }
                sudo apt-get install tmux -y
                ;;
            nooo) echo "dont_install_tmux" | tee $dp/.dont_install >$dn 2>&1 ;;
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
                ;;
            nooo) echo "dont_install_ssh" | tee $dp/.dont_install >$dn 2>&1 ;;
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
            nooo) echo "dont_install_tor" | tee $dp/.dont_install >$dn 2>&1 ;;
            esac
    }    
    sudo which ufw >$dn || sudo grep -q "dont_install_ufw" $dp/.dont_install || {
    export ask=true

        announce "Parmanode wants to install ufw to continue. 
        $green 
        \r$green            y)$orange          OK, do it

        \r$red            n)$orange          Nah, ask me later

        \r$red            nooo)$orange       Nah, never ask again
    "
        case $enter_cont in
            y) [[ $APT_UPDATE == "true" ]] || { sudo apt-get update -y && export APT_UPDATE="true" ; }
                sudo apt-get install ufw -y
                ;;
            nooo) echo "dont_install_ufw" | tee $dp/.dont_install >$dn 2>&1 ;;
            esac
    }    
    dkpg -l | grep -q mdadm >$dn 2>&1 || sudo grep -q "dont_install_mdadm" $dp/.dont_install || {
    export ask=true

        announce "Parmanode wants to install mdadm to continue. 
        $green 
        \r$green            y)$orange          OK, do it

        \r$red            n)$orange          Nah, ask me later

        \r$red            nooo)$orange       Nah, never ask again
    "
        case $enter_cont in
            y) [[ $APT_UPDATE == "true" ]] || { sudo apt-get update -y && export APT_UPDATE="true" ; }
                sudo apt-get install mdadm -y
                ;;
            nooo) echo "dont_install_mdadm" | tee $dp/.dont_install >$dn 2>&1 ;;
            esac
    }    
    which gparted >$dn || sudo grep -q "dont_install_gparted" $dp/.dont_install || {
    export ask=true

        announce "Parmanode wants to install gparted to continue. 
        $green 
        \r$green            y)$orange          OK, do it

        \r$red            n)$orange          Nah, ask me later

        \r$red            nooo)$orange       Nah, never ask again
    "
        case $enter_cont in
            y) [[ $APT_UPDATE == "true" ]] || { sudo apt-get update -y && export APT_UPDATE="true" ; }
                sudo apt-get install gparted -y
                ;;
            nooo) echo "dont_install_gparted" | tee $dp/.dont_install >$dn 2>&1 ;;
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
            nooo) echo "dont_install_netcat" | tee $dp/.dont_install >$dn 2>&1 ;;
       
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
            nooo) echo "dont_install_net-tools" | tee $dp/.dont_install >$dn 2>&1 ;;
    
    esac
fi   
    which notify-send >$dn || if ! sudo grep -q "dont_install_notify-send" $dp/.dont_install ; then
    export ask=true

    announce "Parmanode wants to install notify-send to continue.
        $green 
        \r$green            y)$orange          OK, do it

        \r$red            n)$orange          Nah, ask me later

        \r$red            nooo)$orange       Nah, never ask again (not needed as a server only) 
    "
    case $enter_cont in
            y) [[ $APT_UPDATE == "true" ]] || { sudo apt-get update -y && export APT_UPDATE="true" ; }
                sudo apt-get install libnotify-bin -y
                ;;
            nooo) echo "dont_install_notify-send" | tee $dp/.dont_install >$dn 2>&1 ;;
    
    esac
fi 

    which tune2fs >$dn || if ! sudo grep -q "dont_install_tune2fs" $dp/.dont_install ; then
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
            nooo) echo "dont_install_tune2fs" | tee $dp/.dont_install >$dn 2>&1 ;;
 
    esac
fi 
sudo systemctl status ssh >$dn 2>&1 || sudo systemctl start ssh >$dn 2>&1
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
                sudo apt-get install -y libfuse2
                ;;
            nooo) echo "dont_install_libfuse" | tee $dp/.dont_install >$dn 2>&1 ;;
      
    esac
fi   
[[ $ask == "false" ]] && parmanode_conf_add "dependency_check1=passed" 
rm $tmp/updateonce 2>$dn
debug "end of dependency check"
}