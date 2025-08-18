
function check_ext_ip_update_automation_allowed {

if ! test -f $pdc ; then return 1 ; fi
if ! grep "PARMAGUARD_INSTALLED=true" $pdc ; then return 1 ; fi #only for later version of ParmaDrives with this feature installed
if grep "parmaguard=" $pdc >$dn 2>&1 ; then return 0 ; fi #if this exists, the question has already been asked and answered

set_terminal
if yesorno_blue "
    Do you want to allow your ParmaDrive to report back changes to your external IP to
    Parman's ParmaGaurd server?

    Remember, this server is responsible for checking that your ParmaDrive is connected
    at the current IP address location, and if it's move (stolen), auto unlock at 
    boot is disabled.

    Sometimes, you IP address changes. ParmaDrive can detect this and have the ParmaGuard
    server update the number.

    This can only be done when the ParmaDrive is already decrypted.

    The only way a theif can change use this as a weakness is if they log into your
    computer while it is decrypted, modify the script, and trick the server to accept
    their IP address. Then they take the machine and can decrypt it at home.

    It's outrageously unlikely, but I feel I'm obligated to mention it.

    If this is a concern, you can permanently disable this feature now. This question
    will only ever be asked once. Your decision now is final. Disabling is not a big
    deal, it just means your computer won't autounlock when the IP inevitable changes
    and you'll need to manually decrypt the drive every time it boots up."  "disable" "Disable the feature" "leave" "Leave it be, sounds cool" ; then

#disabling
sudo systemctl disable update_ext_ip.timer
sudo systemctl disable update_ext_ip.service
sudo rm -rf $dp/scripts/update_ext_ip.sh
sudo rm -rf /etc/systemd/system/update_ext_ip.{service,time}

echo "parmaguard=disabled" | sudo tee -a $pdc >$dn 2>&1
else
echo "parmaguard=enabled" | sudo tee -a $pdc >$dn 2>&1
fi

}


