function menu_tools {

while true ; do
set_terminal_high
echo -ne "
########################################################################################$cyan
                                  TOOLS - PAGE 1  $orange
########################################################################################

$cyan              svr)$orange    Screen Video Recording$red$blinkon NEW$blinkoff$orange

$cyan              uc)$orange    Update computer (apt-get for Linux, Homebrew for Macs)

$cyan              au)$orange    Enable/Disable computer auto updates at night (Linux)

$cyan              sr)$orange    System report (for getting troubleshooting help)

$cyan              d)$orange     Delete all preferences to hide menu messages

$cyan              ip)$orange    What's my computer's IP address?

$cyan              pn)$orange    ParmanodL - Flash a mircoSD for a Raspberry Pi
                                                                                      
$cyan              ps)$orange    ParmaShell info 

$cyan              rs)$orange    Parman's easy AF Rsync tool new

$cyan              cc)$orange    Upgrade ColdCard firmware wizard             
$red $blinkon
              n)       More options $blinkoff
$orange
########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;

    n|next)
    menu_tools2
    ;;
    
   sr)
system_report
return 0
;;

 
    m|M) back2main ;;

    cc)
    colcard_firmware
    ;;
    
    au)
    enable_autoupdates
    ;;

    pn|PN|Pn)
    get_parmanodl
    ;;

    ps|PS|Ps)
    parmashell_info
    return 0
    ;;

    uc|UC|update|UPDATE|Update)
    if [[ $OS == "Linux" ]] ; then 
        sudo apt-get update -y && sudo apt-get upgrade -y 
        sudo apt-get --fix-broken install -y
        enter_continue
        success "Your computer" "being updated"
    fi
    if [[ $OS == "Mac" ]] ; then 
        please_wait 
        brew_check || continue 
        brew update ; brew upgrade 
        enter_continue
        success "Your Mac" "being updated"
        if [[ $bashV_major -lt 5 ]] ; then brew install bash ; fi
    fi
    ;;

    ip|IP|iP|Ip)
        IP_address
        return 0
        ;;
    d|D)
        rm $HOME/.parmanode/hide_messages.conf
        echo "Choices reset" ; sleep 0.6 
        ;;


      rs|RS)
      rsync
      ;;

svr)
screen_video_recording
;;


    "")
        return 0 
        ;;

    *)
        invalid 
        ;;
    esac
done
return 0
}

function enable_autoupdates {

if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

if ! yesorno "\n
    Do you want Parmanode to enable auto-updates for the operating system at 4am? The 
    commands to be run are...  $red

                            sudo apt-get update -y
                            sudo apt-get upgrade -y $orange
    " ; then
    #chose disable
    nogsedtest
    sudo gsed -i '/computer_upgrade_script/d' /etc/crontab
    sudo systemctl reload cron >$dn 2>&1
    announce "Computer auto-updates disabled"
    return 1

else
    #chose enable
    if [[ ! -e $dp/computer_upgrade_script.sh ]] ; then make_computer_upgrade_script ; fi
    if ! sudo grep -q "computer_upgrade_script" /etc/crontab ; then
        echo "* 4 * * * root $HOME/.parmanode/computer_upgrade_script.sh #added by Parmanode" | sudo tee -a /etc/crontab >$dn 2>&1
        sudo systemctl reload cron >$dn 2>&1
    fi
    announce "Computer auto-updates enabled"
fi

}

function make_computer_upgrade_script {
cat <<EOF > $dp/computer_upgrade_script.sh
#!/bin/bash
apt-get update -y
apt-get upgrade -y
EOF
sudo chmod +x $HOME/.parmanode/computer_upgrade_script.sh >$dn 2>&1
}
