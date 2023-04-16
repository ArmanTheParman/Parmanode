
#USAGE:
#exit_choice ; if [[ $? == 1 ]]; then return 1 ; fi
#if a case for $choice exists immediately after the function, must include empty string as an option

function exit_choice {
read choice
case $choice in

    q|QUIT|Q|quit)
    exit 0 ;;

    p|P)
    return 1 ;;

    esac

return 2 
}