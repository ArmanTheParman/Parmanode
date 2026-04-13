# USAGE: sign_cert_with_ca prvkey pubkey target

function sign_cert_with_ca {

#default variables    
    RESTRICTED=$parmanode_ca 
    CA_PUBKEY=$parmanode_ca_pubkey
    key="$parmanode_cert_dir/parmanode.local"
    keysigned="$key.crt"

if [[ -n $1 ]] ; then #argument(s) specified
        
    case $1 in
        "default") true ;;
                *) 
                    RESTRICTED="$1" 
                    
                    [[ -z $2 ]] || { sww "No public key specified. Aborting." && return 1 ; }
                    CA_PUBKEY="$2"

                    [[ -z $3 ]] || { sww "No target to sign specified. Aborting." && return 1 ; }
                    key="$3"
                    keysigned="$key.crt"
                    ;;
    esac 
    
    #all three variables specified, now check that they exist
        sudo test -f "$RESTRICTED" || { sww "Private key file not found at $RESTRICTED. Aborting." && return 1 ; }
        sudo test -f "$CA_PUBKEY" || { sww "Public key file not found at $CA_PUBKEY. Aborting." && return 1 ; }
        sudo test -f "$key" || { sww "Key file to sign not found at $key. Aborting." && return 1 ; }

else #no arguments specified

    #change Private key from default (optional)
    while true ; do 

        announce "If you have a certificate authority private key and wish to sign 
        \r    a certificate for your server, type in the full path of the key
        \r    and hit <enter>.

        \r    Otherwise hit <enter> alone to use$green $RESTRICTED $orange
        \r    or$red x$orange and <enter> to abort" 

        case $enter_cont in 
            "") true ;;
             x) return 1 ;; 
             *) yesorno "You chose $enter_cont. Continue?" || continue
                RESTRICTED="$enter_cont" 
                ;;
        esac
        break
    done
    
    #change public key from default (optional)
    while true ; do

        announce "Now type in the full path of the public key, typically called, ca.crt
        \r    and hit <enter>.
            
        \r    Otherwise hit <enter> alone to use$green $CA_PUBKEY$orange
        \r    or$red x$orange and <enter> to abort."

        case $enter_cont in 
            "") true ;;
             x) return 1 ;; 
             *) yesorno "You typed $enter_cont. Continue?" || continue
                CA_PUBKEY="$enter_cont"
                ;;
        esac
        break
    done

    #change target from default (optional)
    while true ; do

if [[ -f "$keysigned" ]] ; then

    if yesorno "Sign the parmanode.local key made with parmanode? Even if your computer's
        \r    hostname is not 'parmanode' it should be fine, and parmanode uses the native 
        \r    hostname of the system embedded in the parmanode.local key." ; then
    else
        while true ; do
            announce "OK, go ahead and type in the full path to your key to sign. 
            \r    x to abort.
            \r    s to skip signing."
            case $enter_cont in 
                x) return 1 ;; 
                s) keysigned="/dev/null" ; break ;; 
                *)
                    yesorno "Use $enter_continue?" || continue
                    key="$enter_cont"
                    keysigned="$key.crt"
                    break
                    ;;
            esac
        done
    fi
    
fi #end argument check

#check files exist again now that choices are final.
    sudo test -f "$RESTRICTED" || { sww "Private key file not found at $RESTRICTED. Aborting." && return 1 ; }
    sudo test -f "$CA_PUBKEY" || { sww "Public key file not found at $CA_PUBKEY. Aborting." && return 1 ; }
    sudo test -f "$key" || { sww "Key file to sign not found at $key. Aborting." && return 1 ; }
    if [[ -f "$keysigned" ]] ; then
            yesorno "Sign the $key? A signature for it already exists and will be overwritten.
            \r    Continue?" || return 1
    fi

# confirmation deprecated with while false
while false ; do
clear ; echo -e "
########################################################################################

    This is the command that will be run. Make a note of where the new files are 
    going.
$green
    sudo openssl x509 -req 
        -in $key
        -CA $CA_PUBKEY
        -CAkey $RESTRICTED
        -CAcreateserial 
        -extfile /etc/ssl/parmanode/parmanode.ext
        -out $keysigned
        -days 36500 -sha256 
        2>>$errorlog 
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
        -in "$key" \
        -CA "$CA_PUBKEY" \
        -CAkey "$RESTRICTED" \
        -CAcreateserial \
        -extfile "/etc/ssl/parmanode/parmanode.ext" \
        -out "$keysigned" \
        -days 36500 -sha256 \
        2>>"$errorlog" || { sww && return 1 ; }

sudo chmod 640 "$parmanode_cert_dir/parmanode.local.crt"
success "The key  has been signed."
}


