function make_parmanode_cert {

#variablize the path
local filepath="/etc/ssl/parmanode/"

sudo openssl req -new -newkey rsa:2048 -nodes -keyout "$filepath/parmanode.local.key" \
                 -out "$filepath/parmanode.local.csr" -subj "/CN=parmanode.local" 2>>$dp/error.log || return 1

return 0
}