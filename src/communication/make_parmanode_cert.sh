function make_parmanode_cert {

#variablize the path
local filepath="/etc/ssl/parmanode/"

sudo openssl req -new -newkey rsa:2048 -nodes -keyout "$filepath/parmanode.local.key" \
                 -out "$filepath/parmanode.local.csr" -subj "/CN=$(hostname).local" 2>>$errorlog || return 1

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