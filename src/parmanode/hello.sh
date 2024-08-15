function hello {

if ! which tor >/dev/null ; then return 0 ; fi
if [[ -e $dp/counted ]] ; then return 0 ; fi

if [[ $OS = Mac ]] ; then
file="/usr/local/var/lib/tor/parmanode-service/hostname"
else
file="/var/lib/tor/parmanode-service/hostname"
fi

if [[ ! -e $file ]] ; then return 0 ; fi 


#anonymous single count using unique identifier for this purpose
message=$(sudo cat $file)
curl -H "Content-Type: application/json" -d "{\"from\":\"$message\"}" --socks5-hostname 127.0.0.1:9050 http://6p7bd3t7pwyd2mgsmtapckhkfyxjaanblomhtm22lt5zb6bicqsfd3yd.onion:6150 && \
touch $dp/counted &

}