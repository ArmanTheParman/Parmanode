function free_up_space {

while true ; do
set_terminal ; echo -e "
########################################################################################

    Over time, the internal drive can get clogged up with unnecessary data.

    The installed programs' log files can keep growing, and so can Parmanode's log
    files, and various other things.
$cyan
    This is an interactive clean up tool.
$orange
    Proceed?
$green
                              y)          Yes
$red
                              n)          Nah
$orange
########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P) return 0 ;; m|M) back2main ;; n|N) return 0 ;;
y|Y) break ;;
*) invalid ;;
esac
done

while true ; do
set_terminal
echo -e "
########################################################################################

    Delete Parmanode log files (mainly useful for sending error reports to Parman)
$green
    y)        yes
$red
    n)        no
$orange
########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P) return 0 ;; n|N) break ;;
y|Y)
sudo rm -rf $dp/*.log ; rm -rf $dp/.*.log
break
;;
*)
invalid
;;
esac
done

while true ; do
set_terminal
echo -e "
########################################################################################

    Delete unused Docker containers/images etc? $bright_blue (This can be very slow,
    potentially several minutes).$orange
$green
    y)        yes
$red
    n)        no
$orange
########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P) return 0 ;; n|N) break ;;
y|Y)
if ! docker ps >/dev/null 2>&1 ; then
set_terminal ; echo "Please run Docker and hit enter to try again." ; enter_continue 
  if ! docker ps >/dev/null 2>&1 ; then
  set_terminal ; echo "Docker not running, skipping." ; enter_continue ; break
  fi
fi
docker system prune
break
;;

*)
invalid
;;
esac
done

while true ; do
if [[ $OS == Mac ]] ; then break ; fi
set_terminal
echo -e "
########################################################################################

    Empty system recycle bin?
$green
    y)        yes
$red
    n)        no
$orange
########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P) return 0 ;; n|N) break ;;
y|Y)
sudo rm $HOME/.local/share/Trash/*
break
;;
*)
invalid
;;
esac
done

while true ; do
set_terminal
echo -e "
########################################################################################

    Delete everything in the /tmp directory?
$green
    y)        yes
$red
    n)        no
$orange
########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P) return 0 ;; n|N) break ;;
y|Y)
sudo rm -rf /tmp/*
break
;;
*)
invalid
;;
esac
done

while true ; do
set_terminal
echo -e "
########################################################################################

    Clear the APT package manager cache? (recommended)
$green
    y)        yes
$red
    n)        no
$orange
########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P) return 0 ;; n|N) break ;;
y|Y)
sudo apt-get clean
break
;;
*)
invalid
;;
esac
done

########################################################################################
# exit if mac from here on
if [[ $OS == Mac ]] ; then break ; fi
########################################################################################

while true ; do
set_terminal
echo -e "
########################################################################################

   Install a text (ncdu) and graphical program (baobab) to help you search for large 
   unneccesary files?
$green
    y)        yes
$red
    n)        no
$orange
########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P) return 0 ;; n|N) break ;;
y|Y)
sudo apt-get update -y
sudo apt-get --fix-broken install -y
sudo apt-get install baobab ncdu -y
success "Baobab has been installed. Just type 'baobab' in the terminal to run it.
    Of course, it won't work if you are using Parmanode through SSH."
break
;;
*)
invalid
;;
esac
done

while true ; do
set_terminal ; echo -e "
########################################################################################

    Linux machines store log files with systemd - they can get pretty massive.

    Would you like Parmanode to clean the log files up a bit, and change settings
    to keep the files form getting too big in the future?
                                    

                                    y)$green yes $orange

                                    n)$red no

$orange
########################################################################################
"
read choice ; set_terminal 
case $choice in
q|Q) exit 0 ;; p|P) return 0 ;; n|N) break ;;
y|yes)
swap_string "/etc/systemd/journald.conf" "SystemMaxUse" "SystemMaxUse=500M"
swap_string "/etc/systemd/journald.conf" "MaxRetentionSec" "MaxRetentionSec=30days"
sudo systemctl restart systemd-journald
break
;;
*) invalid
esac
done

space_left_h=$(df -h | grep -E '\/$' | awk '{print $4}' | tr -d \r)
success "Here ends the internal disk cleanup tool. Parmanode
    detects that you have $space_left_h available on the internal disk."
}
