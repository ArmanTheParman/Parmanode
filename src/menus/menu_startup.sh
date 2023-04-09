function menu_startup {
while true
do
set_terminal
echo "
########################################################################################

                    (i)          Installation / Settings

                    (p)          Run Parmanode 

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

    p)    
        menu_parmanode
        ;;

    q | Q | quit)
        exit 0
        ;;

    *)
        invalid

esac

done

return 0
}
