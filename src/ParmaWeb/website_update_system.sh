function website_update_system {
echo -e "$green" "Updating system, please wait...$blue"
sudo apt-get update -y
sudo apt-get upgrade -y
}