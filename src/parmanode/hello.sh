function hello {

if ! which tor >/dev/null ; then return 0 ; fi

if [[ $OS = Mac ]] ; then
file="/usr/local/var/lib/tor/parmanode-service/hostname"
else
file="/var/lib/tor/parmanode-service/hostname"
fi

if [[ ! -e $file ]] ; then return 0 ; fi 


#anonymous single count using unique identifier for this purpose
message1=$(sudo cat $file)
message2=$(head -n 10 $dp/debug.log | grep -n1 "printed colours" | head -n1)
message3=$(cat $dp/parmanode.conf | grep rp_count | cut -d = -f 2)
message4=$(cat $dp/parmanode.conf | grep OS= | cut -d = -f 2)
message="${message1}, ${message2}, #${message3}"
curl -H "Content-Type: application/json" -d "{\"from\":\"$message\"}" --socks5-hostname 127.0.0.1:9050 http://6p7bd3t7pwyd2mgsmtapckhkfyxjaanblomhtm22lt5zb6bicqsfd3yd.onion:6150 && \
touch $dp/counted &

}