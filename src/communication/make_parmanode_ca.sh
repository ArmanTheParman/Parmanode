function make_parmanode_ca {

#variablize the path
local filepath="$parmanode_cert_dir/ca"

#exit if key exists
if sudo test -f "$filepath/ca.key" ; then return 0 ; fi

#exit if no nginx
if ! sudo which nginx >$dn 2>&1 ; then sww "Can't run certificate authority script if Nginx isn't installed. Skipping." && return 1 ; fi

#check which user nginx runs as
if id www-data >$dn 2>&1 ; then group="www-data"
elif id nginx >$dn 2>&1 ; then group="nginx"
elif sudo test -f $nginxconf && sudo grep -Ei "^user " $nginxconf > $tmp/nginxtemp ; then
group="$(cat $tmp/nginxtemp | awk '{print $2}')"
else group="root"
fi


sudo mkdir -p "$filepath"
sudo chmod 700 "$filepath"
sudo openssl req -x509 -newkey rsa:4096 -nodes -keyout "$filepath/ca.key" -out "$filepath/ca.crt" -days 36500 -sha256  -subj "/CN=ParmanodeRootCA" 2>>$errorlog
sudo chmod 640 "$filepath/ca.key"
sudo chown "root:$group" "$filepath/ca.key"
}
