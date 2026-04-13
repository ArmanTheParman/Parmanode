function make_parmanode_cert {

#variablize the files 
    local keydir="/etc/ssl/parmanode/"
    local keyfile="$keydir/parmanode.local.key"
    local csrfile="$keydir/parmanode.local.csr"

if [[ -e "$keyfile" ]] ; then
    yesorno "Key file already exists. Do you want to overwrite it?" || return 1
fi

sudo openssl req -new -newkey rsa:2048 -nodes -keyout "$keyfile" \
                 -out "$csrfile" -subj "/CN=$(hostname).local" 2>>$errorlog || return 1

cat <<EOF | sudo tee /etc/ssl/parmanode/parmanode.ext >$dn
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = parmanode.local
DNS.2 = $(hostname).local
DNS.3 = localhost
IP.1  = $IP
EOF

return 0
}