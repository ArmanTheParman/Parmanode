function menu_tools {

while true ; do
set_terminal 42 100 
echo -ne "
####################################################################################################$cyan
                                  TOOLS - PAGE 1  $orange
####################################################################################################


$cyan          spoofmac)$orange   Spoof your MAC address when connecting to internet 
$cyan          pay)$orange        Generate a normal lightning invoice from a LN address
$cyan          aip)$orange        See the IPs of all devices connected on your network
$cyan          hn)$orange         Change host name (Linux)
$cyan          svr)$orange        Screen Video Recording
$cyan          ip)$orange         What's my computer's IP address?
$cyan          uc)$orange         Update computer (apt-get for Linux, Homebrew for Macs)
$cyan          sr)$orange         System report (for getting troubleshooting help)
$cyan          d)$orange          Delete all preferences to hide menu messages
$cyan          pn)$orange         ParmanodL - Flash a mircoSD for a Raspberry Pi
$cyan          ps)$orange         ParmaShell info 
$cyan          rs)$orange         Parman's easy AF Rsync tool new
$cyan          cc)$orange         Upgrade ColdCard firmware wizard             
$red 
          n)$blinkon          Next page of tools ...   $blinkoff
$orange
####################################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;

    n|next)
    menu_tools2
    ;;
    spoofmac)
    spoof_mac
    ;;
    pay)
    pay_lightning_address
    ;;
    
   sr)
system_report
return 0
;;
    hn)
        change_hostname ;;
 
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

    uc|UC|update|UPDATE|Update)
    if [[ $OS == "Linux" ]] ; then 
        apt_get_update ; sudo apt-get upgrade -y 
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
      rsync_wizard
      ;;

svr)
screen_video_recording
;;

aip)
see_local_devices
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

function menu_tools2 {

while true ; do
if [[ -z $1 ]] ; then
set_terminal_high
echo -en "
########################################################################################$cyan
                                   TOOLS - PAGE 2  $orange
########################################################################################


$cyan              bd)$orange        Install Bitcoin to a running Docker container
$cyan              as)$orange        AutoSSH reverse proxy tunnel guide
$cyan              curl)$orange      Test bitcoin curl/rpc command (for troubleshooting)
$cyan              gc)$orange        RPC call test to LND (grpcurl)
$cyan              rest)$orange      REST protocol test to LND (info only)
$cyan              rf)$orange        Refresh Parmanode script directory              
$cyan              pass)$orange      Change computer login/sudo password
$cyan              qr)$orange        QRencode command line tool (Linux and Mac)
$cyan              uo)$orange        UTXOracle                                                    
$cyan              lnf)$orange       Install Linux non-free packages and backports
$cyan              ipt)$orange       IPTables menu 
$cyan              grub)$orange      Install (or reinstall) GRUB bootloader 
$cyan              ssh)$orange       Enable SSH server on Macs...

$orange
########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
else
choice="$1"
fi
case $choice in
q|Q) exit ;;  m|M) back2main ;; p|P) return 0 ;;

bd)
install_bitcoin_docker
return 0
;;

curl)
bitcoin_curl
return 0
;;

gc)
grpccurl_call
;;

rf)
parmanode_refresh
return 0
;;


rest)
rest_protocol_test
;;

as)
autossh_setup
;;

uo)
announce "This is a decentralised Bitcoin Price Calculator.
    Bitcoin needs to be running for it to work.
    Use$cyan <control> c$orange to exit it."
NODAEMON=true
pn_tmux "python3 $pn/src/tools/UTXOracle.py 
    echo 'hit <enter> to continue' ; read" "UTXOracl"
unset NODAEMON
;;

lnf)
clear
echo 'deb http://deb.debian.org/debian bookworm-backports main' | sudo tee -a /etc/apt/sources.list
apt_get_update
sudo apt install -t bookworm-backports linux-image-amd64 linux-headers-amd64 -y
sudo apt-get install firmware-iwlwifi firmware-linux firmware-linux-nonfree -y
if ! [[ $* =~ silent ]] ; then success "Packages installed" ; fi
;;

pass)
set_terminal
yesorno "Are you sure you want to change your computer's password? If yes, you'll
    first be asked for the old password, then the new one twice." || continue
passwd && success "The password has been changed."
;;

qr)
which qrencode >$dn || install_qrencode || continue
menu_qrencode
;;

ipt)
menu_iptables
;;

grub)
install_grub
;;
ssh)
enable_ssh_mac
;;
"")
continue ;;
*)
invalid 
;;
esac
done
return 0
}

function enable_ssh_mac {

announce "New macs don't allow you to log in remotely via SSH by default.
    Not to worry, Parman has your back.

    First step is to enable Disk Access. Parman can't do this bit for you, it
    has to be done with the mouse.

    Find System Settings > Privacy & Security > Full Disk Access, then enable

    Hit <enter> and an image will open up for you as a guide."

open $HOME/parman_programs/parmanode/src/graphics/ssh_enable.png

yesorno "Have you enabled Full Disk Access. If so, SSH can now be enabled." || return 1

sudo systemsetup -setremotelogin on && success "SSH server enabled on your Mac."

}
