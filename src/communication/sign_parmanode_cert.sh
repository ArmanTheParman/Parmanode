function sign_parmanode_cert {

    local filepath="$parmanode_cert_dir"

    sudo openssl x509 -req \
        -in "$filepath/parmanode.local.csr" \
        -CA "$filepath/ca/ca.crt" \
        -CAkey "$filepath/ca/ca.key" \
        -CAcreateserial \
        -extfile /etc/ssl/parmanode/parmanode.ext \
        -out "$filepath/parmanode.local.crt" \
        -days 36500 -sha256 \
        2>>"$dp/error.log" || return 1

    sudo chmod 640 "$filepath/parmanode.local.crt"
    return 0
}
