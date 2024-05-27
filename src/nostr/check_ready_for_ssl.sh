function check_ready_for_ssl {
if [[ -z $domain_name ]] ; then return 0 ; fi

while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                TLS CERTIFICATE
$orange
    For SSL connections (secure sockets layer, encrypted communication) you'll 
    need a  TLS certificate for that, which Parmanode can set up for you, but it
    requires ports$green 80$orange and$green 443$orange to be open on the rounter
    pointing to this computer's IP address. 
    
    If you haven't done that yet, the procedure will fail.

    Choices...
$cyan
                    skip)$orange     Do TLS certifcate yourself later from
                                Parmanode menu
$cyan
                    now) $orange     Parmanode will get a certificate now
                                and set up SSL

########################################################################################
"
choose xmq ; read choice ; set_terminal
case $choice in 
q|Q) exit ;; m|M) back2main ;;
skip)
return 1
;;
now)
return 0
;;
*)
invalid ;;
esac
done
}