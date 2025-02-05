function make_external_IP_script {
test -f $dp/update_external_IP.sh && return 0

cat <<'EOF' >> $dp/update_external_IP.sh
#!/bin/bash
count=0
while true ; do 
    IP=$(curl -s ifconfig.me && break
    sleep 2 
    count=$((count + 1))
    [[ $count -gt 4 ]] && break
done
grep -q $IP $HOME/.parmanode/parmanode.conf && exit 0
gsed -i "s/external_IP.*$/external_IP=$IP/" $HOME/.parmanode/parmanode.conf
exit 0
EOF

sudo chmod +x $dp/update_external_IP.sh
}