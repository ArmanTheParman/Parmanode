function mod_thub_env {
file=$hp/thunderhub/.env.local #adding '.local' prevents overriding file when updating.

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

while true ; do
set_terminal ; echo -e "
########################################################################################

    Run over Tor?
$green
                              y)       yes $bright_blue    (will set to proxy 127.0.0.1:9050)
$red
                              n)       no
$orange
########################################################################################
"
choose "xpmq" ; read choice
case $choice in
q|Q) exit ;; p|P) return 1 ;; n|N) break ;;
y)
if ! which tor >/dev/null 2>&1 ; then install_tor ; fi
swap_string "$file" "TOR_PROXY_SERVER=" "TOR_PROXY_SERVER=socks://127.0.0.1:9050"
;;
*)
invalid ;;
esac
done

set_terminal ; echo -e "
########################################################################################

    Please note, Thunderhub will allow connections from computers without cookie
    authentication, which is not considered best security practice - It's fine for
    your own home network, that's secure, but if you were to expose the wallet to
    the internet, eg access via a domain, open ports on your router etc, then this
    method is suboptimal. 
    
    I may incorporate cookie authentication options later, but for now this will be 
    perfectly sufficient and private for most people. If you have the skills you can 
    modify the settings yourself insted of waiting for me.

########################################################################################
"


}