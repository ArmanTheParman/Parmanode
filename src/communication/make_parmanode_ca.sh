function make_parmanode_ca {

#exit if no nginx
    if ! sudo which nginx >$dn 2>&1 ; then sww "Can't run certificate authority script if Nginx isn't installed. Skipping." && return 1 ; fi

#variablize the path
    [[ -d $parmanode_cert_dir ]] || sudo mkdir -p "$parmanode_cert_dir"
    filepath="$parmanode_cert_dir/ca"       #parmanode_cert_dir="$macprefix/etc/ssl/parmanode"

#exit if key exists
    if sudo test -f "$filepath/ca.key" && [[ $1 != silent ]] ; then 
        yesorno "Parmanode CA key already exists. Do you want to overwrite it?" || return 1 
    fi

#check which user nginx runs as
    if id www-data >$dn 2>&1 ; then group="www-data"
    elif id nginx >$dn 2>&1 ; then group="nginx"
    elif sudo test -f $nginxconf && sudo grep -Ei "^user " $nginxconf > $tmp/nginxtemp ; then
    group="$(cat $tmp/nginxtemp | awk '{print $2}')"
    else group="root"
    fi

#make the CA key
    sudo mkdir -p "$filepath"
    sudo chmod 700 "$filepath"
    sudo openssl req -x509 -newkey rsa:4096 -nodes -keyout "$filepath/ca.key" -out "$filepath/ca.crt" -days 36500 -sha256  -subj "/CN=ParmanodeRootCA" 2>>$errorlog
    sudo chmod 640 "$filepath/ca.key"
    sudo chown "root:$group" "$filepath/ca.key"

return 0
}
