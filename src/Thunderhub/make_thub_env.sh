function make_thub_env {
copy_thub_env || return 1
master_password_thub || return 1
thub_lnd

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
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; M|m) back2main ;; d|D) break ;;
soy) 
sudo gsed -i "/THEME='dark'/c\THEME='light'"  $file
break ;;
*) invalid ;;
esac
done
}
