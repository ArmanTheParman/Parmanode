function menu_tools {

while true ; do
set_terminal
echo -e "
########################################################################################
  $cyan
                               P A R M A N O D E - Tools   $orange


              (pn)    ParmanodL - Flash a mircoSD for a Raspberry Pi
                                                                                      
              (ps)    ParmaShell info 

              (ip)    What's my computer's IP address?

              (md)    Migrate/Revert an external drive.

              (um)    Unmount your Parmanode external drive 
                      (stops Bitcoin/Fulcrum/Electrs if running) - Linux only

              (mm)    Mount the Parmanode drive - Linux only
                
              (d)     Delete your previous preferences to hide certain Parmanode
                      messages
                 
              (u)     Update computer (apt-get for Linux, Homebrew for Macs)

              (h)     Check system resources with \"htop\" (installed if needed)

              (udev)  Add udev rules for HWWs (only needed for Linux)

              (aa)    Turn on/off autoupdates

              (rs)    Parman's easy AF Rsync tool$red new $orange

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal

case $choice in
    
    m|M) back2main ;;

    pn|PN|Pn)
    get_parmanodl
    ;;

    ps|PS|Ps)
    parmashell_info
    return 0
    ;;

    u|U|up|UP|update|UPDATE|Update)
    if [[ $OS == "Linux" ]] ; then sudo apt-get update -y && sudo apt-get upgrade -y ; fi
    if [[ $OS == "Mac" ]] ; then 
        please_wait 
        brew_check || continue 
        brew update ; brew upgrade 
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
    um|UM|Um)
        safe_unmount_parmanode menu
        ;;

    mm|MM|Mm|mount)
        mount_drive menu
        if mount | grep -q parmanode ; then
        announce "Drive mounted."
        fi
        ;;
    aa|AA|Aa)
        autoupdate_toggle
        ;;
    p|P)
        return 0
        ;;

    h|H|htop|HTOP|Htop)

        announce "To exit htop, hit$cyan q$orange"

        if [[ $OS == "Mac" ]] ; then htop ; break ; return 0 ; fi

        if ! which htop ; then sudo apt-get install htop -y >/dev/null 2>&1 ; fi

        htop

        ;;
    udev|UDEV)
      if grep -q udev-end < $dp/installed.conf ; then
      announce "udev already installed."
      return 0
      fi
      udev
      ;;

      md|MD)
      menu_migrate
      ;;

      rs|RS)
      rsync
      ;;

      q|Q|Quit|QUIT)
        exit 0
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

