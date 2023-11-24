function systemd-resolved_disable {

clear
announce "Parmanode will now test if 'systemd-resoved' is off. You need to hit q to 
    keep going after a status printout appears"

sudo systemctl status systemd-resolved.service || return 0 #this 0 is not a typo
while true ; do
set_terminal ; echo -e "
########################################################################################

    It looks like your device has$cyan systemd-resolved service$orange running. This is a
    program related to domain names used by services on your computer. PiHole will
    be taking over this job, so it needs to be disabled. If you have some reason
    to keep it, then choose 'abandon' Pi Hold installation.

                     a)         Abandon installation

                     <enter>    Disables the service and continues installation 

########################################################################################
"
choose "xpmq" ; read choice
case $choice in
m|M) back2main ;;
q|Q) exit ;;
p|P) return 1 ;;
a|A) return 1 ;;
"") break ;;
*) 
invalid ;;
esac
done

#disable service
sudo systemctl stop systemd-resolved.service
sudo systemctl disable systemd-resolved.service
sudo sed -i '/^\s*nameserver/d' /etc/resolv.conf >/dev/null 2>&1
echo "nameserver 8.8.8.8" | sudo tee -a /etc/resolv.conf >/dev/null 2>&1
return 0
}