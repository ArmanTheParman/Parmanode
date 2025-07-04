function website_update_system {
echo -e "$green" "Updating system, please wait...$blue"
sudo apt-get update -y && export APT_UPDATE="true"
sudo apt-get upgrade -y
}