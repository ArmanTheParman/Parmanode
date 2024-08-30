function hello {

#This function counts the usage of parmanode from version 3.41.11 onwards.

#Care has been taken to not collect any personal information, particularly IP 
#    addresses (hence the use of Tor). I previously had not collected usage
#    stats as IP addresses are sent in headers, which requires me to be trusted
#    with the data - not to save it, leak it and not use if for evil 
#    Bill Gates like purposes.

#The command is run in the background (using the & directive), for parallel 
#    execution and speed. Don't want to slow down laod times.

#A specific single purpose onion address has been created as an identifier under 
#    /var/lib/tor/parmanode-service using make_parmanode_tor_service function.
#    This is not a functional server, the onion is just a public key. I may
#    develop some optional feature with it in the distant future.

#The program sends a POST curl connection to Parman's Tor server which gathers 
#    info as stated in the message 1-4 statements. This destination server is a 
#    simple python program listening on the specific port and writing POST data 
#    to a secured file.

#The data will be used to glean information about Parmande usage, and the value 
#    of putting effort into further improvement.

#The data is protected, but even if leaked, there is no information about users,
#    just an anon onion address and some usage stats, eg like the OS in use.

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
if [[ ! -e $dp/parmanode_all.log ]] ; then touch $dp/parmanode_all.log ; fi
message2=$(head -n1 $dp/parmanode_all.log | cut -d ' ' -f 1-6 )
#the count of the number of times the program has been run
if [[ ! -e $dp/parmanode.conf ]] ; then touch $dp/parmanode.conf ; fi
message3=$(cat $dp/parmanode.conf | grep rp_count | cut -d = -f 2)
#the operating system, linux vs Mac
message4=$(cat $dp/parmanode.conf | grep OS= | cut -d = -f 2)
#combined
message="${message1}, ${message2}, #${message3}, OS:${message4}"
#Anonymous curl POST request to private server over Tor, run in background to not slow boot up time
curl -H "Content-Type: application/json" -d "{\"from\":\"$message\"}" --socks5-hostname 127.0.0.1:9050 http://6p7bd3t7pwyd2mgsmtapckhkfyxjaanblomhtm22lt5zb6bicqsfd3yd.onion:6150 && \
touch $dp/counted &
}