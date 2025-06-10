function make_external_IP_script {

test -f $dp/scripts/update_external_IP2.sh && return 0
rm $dp/update_external_IP.sh >/dev/null 2>&1

cat <<'EOF' >> $dp/scripts/update_external_IP2.sh
#!/bin/bash
count=0
unset IP
while true ; do 
    IP=$(curl -s ifconfig.me)
    [[ -n "$IP" ]] && break
    sleep 2 
    count=$((count + 1))
    [[ $count -gt 4 ]] && break
done
grep -q "external_IP=$IP" $HOME/.parmanode/parmanode.conf && exit 0
gsed -i "s/external_IP.*$/external_IP=$IP/" $HOME/.parmanode/parmanode.conf
grep -q "external_IP=" $HOME/.parmanode/parmanode.conf || echo "external_IP=$IP" >> $HOME/.parmanode/parmanode.conf
exit 0
EOF

sudo chmod +x $dp/scripts/update_external_IP2.sh
}