function uninstall_torrelay {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall Tor Relay 
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose xpmq ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
n) return 1 ;; y) break ;;
rem)
rem="true"
break
;;
esac
done

local file="/etc/tor/torrc"

sudo sed -i '/#Tor Relay Installation.../,/#End Tor Relay Installation./d' $file
sudo apt-get purge nyx -y

install_config_remove "torrelay"
success "Your Tor Relay" "being uninstalled."
}