function delete_website_database {
set_terminal ; echo -e "
########################################################################################
$red $blinkon
    Warning, you are about to delete your website's database - this holds all your
    website pages! $blinkoff
$orange
    Do you really want to do this?
$red
                        do_it)      Yeah, delete, my website is shit.
$green
                        n)          No! I made a mistake
$orange
########################################################################################
"
read choice ; set_terminal 
case $choice in
q|Q) exit ;; p|P|n|N|NO|No) return 1 ;;
do_it)
sudo mysql -u root -p -e "DROP DATABASE website; DROP USER \"parmanode\"@\"localhost\";"
parmanode_conf_remove "website_database"
;;
*)
return 1 
;;
esac
}