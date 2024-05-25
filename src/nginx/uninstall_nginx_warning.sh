function uninstall_nginx_warning {

while true ; do
set_terminal ; echo -e "
########################################################################################

	Uninstalling Nginx might cause problems. Parmanode uses Nginx for other programs
	you may have installed.

	Only proceed if you really know what you're doing.

	Remove Nginx?
$red
                      removenginx)    Remove Nginx
$green
                      a)              Abort
$orange
########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P|a) return 1 ;; removenginx) return 0 ;;
esac
done

}