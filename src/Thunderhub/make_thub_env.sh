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
case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; M|m) back2main ;; d|D) break ;;
soy) 
swap_string "$file" "THEME='dark'" "THEME='light'" 
break ;;
*) invalid ;;
esac
done

set_terminal ; echo -e "
########################################################################################

    Please note, because Thunderhub will allow connections from computers without 
    cookie authentication, it's best to$red not expose the wallet to the internet,$orange eg 
    access via a domain, open ports on your router etc, as password authentication
    is not the most secure method.

    If you do want to do that, you should enable cookie authentication. Parmanode does
    not support that yet, but you can configure it yourself if you know what you're 
    doing.

########################################################################################
"
enter_continue
set_terminal
}