function wireless_driver_install {

if [[$OS != Linux ]] ; then announce "Linux Only" ; return 1 ; fi

while true ; do
set_terminal ; echo -e "
########################################################################################

    Install rtl8812au wireless driver?$green    y$orange   or$red   n $orange

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P) return 0 ;; m|M) back2main ;; n|N) return 1 ;;
y) break;;
*) invalid ;;
esac
done


sudo apt-get update -y
sudo apt-get upgrade -y

if [[ $computer_type == Pi ]] ; then
sudo apt install -y raspberrypi-kernel-headers build-essential bc dkms linux-headers-generic 
else
sudo apt install -y build-essential bc dkms linux-headers-generic 
fi

cd $hp
mkdir wireless 
cd wireless 
git clone --depth 1 https://github.com/morrownr/8812au-20210629.git
cd 8812au*

set_terminal ; echo -e "
########################################################################################

    After the install is done (a few minutes) you will be asked if you want to edit
    the configuration file - it's fine to leave it as defaults.

########################################################################################
"
enter_continue

sudo ./install-driver.sh 

success "The rtl8812au wireless driver has been installed. Reboot is required.
    Please do that now."
}