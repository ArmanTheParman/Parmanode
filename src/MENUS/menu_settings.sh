function menu_settings {
while true ; do
source $hm >/dev/null 2>&1 #hide messages
set_terminal ; echo -e "
########################################################################################
$cyan
                                   SETTINGS    $orange


         c)        Change colours

        an)        Hide/Show Main Menu announcements

        aa)        Turn on/off autoupdates

######################################################################################## 
"
choose "xpmq" ; read choice
case $choice in 
m|M) back2main ;;
Q|q|QUIT|Quit|quit) exit 0 ;; 
p|P) return ;;
c|C) change_colours ; return 0 ;;
an)
if [[ $announcements == off ]] ; then
delete_line "$hm" "announcements="
echo "announcements=on" | tee -a $hm 
else
delete_line "$hm" "announcements="
echo "announcements=off" | tee -a $hm
fi
;;
aa|AA|Aa)
autoupdate_toggle
;;
*) invalid ;;
esac
done
}