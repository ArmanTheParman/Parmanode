function sign_parmanode_cert {
#This function is a blueprint, but a private key is needed.
#The private key signs the parmanode certificate and the signature is embedded inside
#the parmanode.local.crt file

return 0
    local filepath="$parmanode_cert_dir"

    CA_private_key="$RESTRICTED"

    sudo openssl x509 -req \
        -in "$filepath/parmanode.local.csr" \
        -CA "$filepath/ca/ca.crt" \
        -CAkey "$RESTRICTED" \
        -CAcreateserial \
        -extfile /etc/ssl/parmanode/parmanode.ext \
        -out "$filepath/parmanode.local.crt" \
        -days 36500 -sha256 \
        2>>"$dp/error.log" || return 1

    sudo chmod 640 "$filepath/parmanode.local.crt"
    return 0
}


