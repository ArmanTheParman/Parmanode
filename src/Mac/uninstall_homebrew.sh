function uninstall_homebrew {

while true ; do
echo -en "
########################################################################################

    Are you sure you want to uninstall$cyan HomeBrew$orange?

$cyan
                  y)$orange        yes, uninstall
$cyan
                  n)$orange        nah

########################################################################################
"
choose xq ; read choice ; set_terminal
case $choice in
q|Q) exit ;;
y)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"

sudo rm -rf /opt/homebrew/Homebrew >$dn 2>&1
sudo rm -rf /opt/homebrew/Caskroom >$dn 2>&1
sudo rm -rf /opt/homebrew//Cellar >$dn 2>&1
sudo rm -rf /opt/homebrew//bin/brew >$dn 2>&1
sudo rm -rf /usr/local/Homebrew >$dn 2>&1
sudo rm -rf /usr/local/Caskroom >$dn 2>&1
sudo rm -rf /usr/local/Cellar >$dn 2>&1
sudo rm -rf /usr/local/bin/brew >$dn 2>&1
sudo rm -rf ~/.brew >$dn 2>&1
sudo rm -rf ~/.homebrew >$dn 2>&1

break
;;
n)
return 0
;;
*)
invalid
;;
esac
done
}