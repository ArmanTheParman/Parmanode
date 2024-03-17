function website_update_system {
echo -e "$cyan" "Updating system, please wait...$orange"
sudo apt-get update -y
sudo apt-get upgrade -y
}