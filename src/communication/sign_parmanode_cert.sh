function sign_parmanode_cert {

local filepath="$parmanode_cert_dir"

while true ; do
    announce "If you have a certificate authority private key and wish to sign 
    \r    a certificate for your server, type in the full path and hit <enter>.

    \r    Otherwise hit <enter> alone to abort."
    case $enter_cont in "") return 1 ;; esac
    yesorno "You typed $enter_cont. Continue?" || continue
    local RESTRICTED="$enter_cont"

    announce "Now type in the full path of the public key, typically called, ca.crt
    \r    and hit <enter>.
        
    \r    Otherwise hit <enter> alone to abort."
    case $enter_cont in "") return 1 ;; esac
    yesorno "You typed $enter_cont. Continue?" || continue
    local CA_PUBKEY="$enter_cont"
    break

done

if yesorno "Sign the parmanode.local key made with parmanode? Even if your computer's
    hostname is not 'parmanode' it should be fine, and parmanode uses the native 
    hostname of the system embedded in the parmanode.local key." ; then
    local key="$filepath/parmanode.local"
else
    while true ; do
         announce "OK, go ahead and type in the full path to your key to sign. x to abort."
         case $x in "") return 1 ; esac
         yesorno "Use $enter_continue?" || continue
         break
    done
    local key="$enter_cont"
fi


while true ; do
clear ; echo -e "
########################################################################################

    This is the command that will be run. Make a note of where the new files are 
    going.
$green
    sudo openssl x509 -req 
        -in $key.csr
        -CA $CA_PUBKEY
        -CAkey $RESTRICTED
        -CAcreateserial 
        -extfile /etc/ssl/parmanode/parmanode.ext
        -out $key/.crt 
        -days 36500 -sha256 
        2>>$dp/error.log 
$orange
   Go ahead?
   $green 
                      y)$orange              yes
   $red
                      n)$orange              no


########################################################################################
"
choose xpmq ; read choice ; clear
jump $choice
case $choice in
q|Q) exit ;; m|M) back2main;; n|N|p|P) return 1 ;;
y)
break ;;
*) invalid ;;
esac
done

clear

    sudo openssl x509 -req \
        -in "$key.csr" \
        -CA "$CA_PUBKEY" \
        -CAkey "$RESTRICTED" \
        -CAcreateserial \
        -extfile "/etc/ssl/parmanode/parmanode.ext" \
        -out "$key.crt" \
        -days 36500 -sha256 \
        2>>"$dp/error.log" || { sww && return 1 ; }

sudo chmod 640 "$filepath/parmanode.local.crt"
success "The key has been signed."
}


