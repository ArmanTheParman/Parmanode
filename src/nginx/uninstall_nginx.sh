function uninstall_nginx {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall Nginx?
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
y) break ;;
n) return 1 ;;
*) invalid ;;
esac
done

if [[ $OS == Mac ]] ; then brew services stop nginx ; brew uninstall nginx ; fi
if [[ $OS == Linux ]] ; then sudo systemctl stop nginx ; sudo apt-get purge nginx -y ; fi
installed_config_remove "nginx"
return 0
}