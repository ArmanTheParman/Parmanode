function website_update_system {

while true ; do
set_terminal ; echo -e "
########################################################################################

    Updating the OS with apt-get, OK?
$green
                              y)           Yes
$red 
                              n)           No
$orange
########################################################################################
" ; choose "xpmq" ; read choice ; set_terminal
case $choice in q|Q) quit 0 ;; n|N|NO|no|p|P) return 1 ;; y|Y) break ;; *) invlid ;; esac 
done

echo -e "$green Running apt-get update...$orange" ; sleep 1
sudo apt-get update -y
echo -e "green Running apt-get upgrade"
sudo apt-get upgrade -y
}