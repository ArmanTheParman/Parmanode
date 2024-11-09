function check_variables {
echo -en "    ${green}Checking environment variables...$orange

        \r    Hit$cyan <enter>$orange for all, or type a specific search."

read choice

case $choice in
q|Q) exit ;; m|M) back2main ;;
"")
env
enter_continue
;;
*)
env | grep -q $choice 
enter_continue
;;
esac
}