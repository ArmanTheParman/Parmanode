
function choose_database_name {

while true ; do
set_terminal ; echo -e "$blue
########################################################################################

    The default name for the database and directory where information about the
    website is stored is called 'website'. This may be a problem for people tinkering
    and installing more than one site on the same computer. In that case you can
    choose one of the following names - Parmanode will check they don't already
    exists. Be warned setting up more than one website with Parmanode is not going
    to run perfectly smoothly, more work needs to be done to make a multisites
    system sufficiently robust.

                        d)$orange       website      $green(default) $blue
                        2)$orange       website2$blue
                        3)$orange       website3$blue
                        4)$orange       website4$blue
                        5)$orange       website5$blue
                        6)$orange       website6$blue
                        7)$orange       website7$blue
                        8)$orange       website8$blue
                        9)$orange       website9$blue


########################################################################################
"
choose x ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
d) export website="website" ; break ;;
2) export website="website2" ; break ;;
3) export website="website3" ; break ;;
4) export website="website4" ; break ;;
5) export website="website5" ; break ;;
6) export website="website6" ; break ;;
7) export website="website7" ; break ;;
8) export website="website8" ; break ;;
9) export website="website9" ; break ;;
*) invalid ;;
esac
done

debug "check website database name: $website"

return 0
}