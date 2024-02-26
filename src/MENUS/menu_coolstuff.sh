
function menu_coolstuff {

while true ; do
set_terminal
echo -e "
########################################################################################
#                                                                                      #
#    P A R M A N O D E --> Main Menu --> Install Menu  -->$cyan Other Install $orange              #
#                                                                                      #
########################################################################################
#                                                                                      #
#                                                                                      #
#                                                                                      #
#          cb)     Parman's recommended computer books (pdfs) +/- update contents      #
#                                                                                      #
#                                                                                      #
#$cyan          ... more soon                                                              $orange #
#                                                                                      #
#                                                                                      #
#                                                                                      #
#                                                                                      #
########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in
q|Q) exit 0 ;; p|Q) return 1 ;; m|M) back2main ;;
cb)
get_computerbooks
;;
*) invalid ;; esac ; done

}

function get_computerbooks {

if [[ -d $hp/parman_books ]] ; then
set_terminal ; echo -e "
########################################################################################

    It looks like you've previously downloaded the books directory.

    You have options:

            1)    Update the contents (Who knows, I might have added more stuff)

            2)    Uninstall/delete the directory

            3)    Do nothing, abort

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 
q|Q) exit 0 ;; p|P) return 1 ;; m|M) back2main ;;
1) 
cd $hp/parman_books
git pull && success "The parman_books directory has been updated" && return 0
enter_continue
continue
;;
2)
cd && sudo rm -rf $hp/parman_books >/dev/null 2>&1
success "The parman_books directory is gone"
return 0
;;
3)
return 0
;;
esac
else

cd $hp
git clone --depth 1 https://github.com/ArmanTheParman/parman_books.git

success "Parman's recommended computer books has been downloaded and can be
    found on your drive at: $cyan

    $hp/parman_books/ $orange

    "
return 0
fi
}