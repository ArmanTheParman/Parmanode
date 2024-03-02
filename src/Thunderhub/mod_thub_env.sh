function mod_thub_env {
file=$hp/thunderhub/.env.local #adding '.local' prevents overriding file when updating.
make_thub_env

while true ; do
set_terminal ; echo -e "
########################################################################################

    You want the dark theme right? Right??
$green
                          d)       dark, obviously
$red
                          soy)     I'm a light theme maxi
$orange
########################################################################################
"
choose "xpmq" ; read choice
case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; M|m) back2main ;; d|D) break ;;
soy) 
swap_string "$file" "THEME='dark'" "THEME='light'" 
break ;;
*) invalid ;;
esac
done
}