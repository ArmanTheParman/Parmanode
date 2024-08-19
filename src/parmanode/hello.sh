function hello {

#This function counts the usage of parmanode from version 3.41.11 onwards.
#Care has been taken to not collect any personal information, particularly IP 
#    addresses (hence the use of Tor).
#The command is run in the background (using & directive), for parallel execution 
#    and speed.
#A specific single purpose onion address has been created as an identifier under 
#    /var/lib/tor/parmanode-service using make_parmanode_tor_service function.
#The program sends a POST curl connection to Parman's Tor server which gathers 
#    info as stated in the message 1-4 statements. This server is a simple
#    python program listening on the specific port and writing POST data to a 
#    secured file.
#The data will be used to glean information about Parmande usage, and the value 
#    of putting effort into further improvement.
#The data is protected, but even if leaked, there is no information about users,
#    just an anon onion address and some usage stats.
if [[ -e $pn/.there ]] ; then return 0 ; fi

if ! which tor >/dev/null ; then return 0 ; fi
if [[ $OS = Mac ]] ; then
file="/usr/local/var/lib/tor/parmanode-service/hostname"
else
file="/var/lib/tor/parmanode-service/hostname"
fi

if sudo test -e "$file" >/dev/null 2>&1 ; then
#onion address for parmanode-service
message1=$(sudo cat $file)
else
message1=""
fi

#approximate date of first install 
message2=$(head -n1 $dp/parmanode_all.log | cut -d ' ' -f 1-6 )
#the count of the number of times the program has been run
message3=$(cat $dp/parmanode.conf | grep rp_count | cut -d = -f 2)
#the operating system, linux vs Mac
message4=$(cat $dp/parmanode.conf | grep OS= | cut -d = -f 2)
#combined
message="${message1}, ${message2}, #${message3}"
#Anonymous curl POST request to private server over Tor, run in background to not slow boot up time
curl -H "Content-Type: application/json" -d "{\"from\":\"$message\"}" --socks5-hostname 127.0.0.1:9050 http://6p7bd3t7pwyd2mgsmtapckhkfyxjaanblomhtm22lt5zb6bicqsfd3yd.onion:6150 && \
touch $dp/counted &
}