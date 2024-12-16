function menu_tools {

while true ; do
set_terminal_high
echo -ne "
########################################################################################$cyan
                                  TOOLS - PAGE 1  $orange
########################################################################################


$cyan              u)$orange     Update computer (apt-get for Linux, Homebrew for Macs)

$cyan              sr)$orange    System report (for getting troubleshooting help)

$cyan              d)$orange     Delete all preferences to hide menu messages

$cyan              ip)$orange    What's my computer's IP address?

$cyan              pn)$orange    ParmanodL - Flash a mircoSD for a Raspberry Pi
                                                                                      
$cyan              ps)$orange    ParmaShell info 

$cyan              rs)$orange    Parman's easy AF Rsync tool new

$cyan              cc)$orange    Upgrade ColdCard firmware wizard             
$red $blinkon
              next)    More options $blinkoff
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

    pn|PN|Pn)
    get_parmanodl
    ;;

    ps|PS|Ps)
    parmashell_info
    return 0
    ;;

    u|U|up|UP|update|UPDATE|Update)
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