function menu_add_extras {
while true
menu_add_source
do
set_terminal
echo -e "
########################################################################################
#                                                                                      #
#    P A R M A N O D E --> Menu principal --> Menu de instalação -->$cyan Extras        $orange              #
#                                                                                      #
########################################################################################
#                                                                                      #
#                                                                                      #
#$cyan              (rr)$orange      RAID - juntar drives                                          #
#                                                                                      #
#$cyan              (h)$orange       HTOP - verificar os recursos do sistema                       #
#                                                                                      #
#$cyan              (u)$orange       Adicionar regras UDEV para HWWs (apenas necessário para Linux)#
#                                                                                      #
#$cyan              (fb)$orange      Livros gratuitos recomendados por Parman (pdfs)               #
#                                                                                      #
#                                                                                      #
########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 0 ;; m|M) back2main ;;

rr)
    install_raid 
    return 0
;; 

h|H|htop|HTOP|Htop)

    if [[ $OS == "Mac" ]] ; then htop ; break ; return 0 ; fi
    if ! which htop ; then sudo apt-get install htop -y >$dn 2>&1 ; fi
    announce "To exit htop, hit$cyan q$orange"
    htop
;;

u|U|udev|UDEV)

    if grep -q udev-end $dp/installed.conf ; then
    announce "udev já instalado."
    return 0
    fi
    udev
;;
fb|FB)
get_books
;;

*)
    invalid
    continue
    ;;
esac
done

return 0

}

