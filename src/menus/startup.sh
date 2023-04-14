function startup {
while true ; do
set_terminal
echo "
########################################################################################

                               P A R M A N O D E - STARTUP MENU 
            

                 (i)         Install/Uninstall ......  (Hint: start here)

                 (r)         Run Parmanode

                 (a)         About Parmanode

                 (pp)        Parmanode Premium 

                 (m)         Bitcoin Mentorship Info
 

########################################################################################
"
choose "xq"
echo "
(Note, <enter> is the same as <return>)"
read choice

case $choice in

    i)
        menu_install
        ;;

    r|R|R|r)    
        menu_parmanode
        ;;

    a|A)
        about
        ;;

    m|M)
        mentorship
        ;;

    q | Q | quit)
        exit 0
        ;;

    *)
        invalid
	;;

esac

done

return 0
}
