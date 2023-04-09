#Refactored for Linux

function menu_startup {
set_terminal
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
    clear
    menu_install
    ;;

p)    
    menu_parmanode
    continue
    ;;

q | Q | quit)
    exit 0
    ;;
*)
    invalid
esac

done
}
