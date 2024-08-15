function apply_patches {
#patches ; each patch adds variable to parmanode.conf, sourced higher up
#patch=n
#get $patch from parmanode.conf
temp_patch
openssh_patch
make_parmanode_service
make_tor_script_mac
make_parmanode_tor_service
hello

case $patch in 
1) 
patch_2 ; patch_3 ; patch_4 ; patch_5 ; patch_6 ;;
2)
patch_3 ; patch_4 ; patch_5 ; patch_6 ;;
3)
patch_4 ; patch_5 ; patch_6 ;;
4)
patch_5 ; patch_6 ;;
5)
patch_6 ;;
6)
return 0 ;;
*) 
patch_1 ; patch_2 ; patch_3 ; patch_4 ; patch_5 ; patch_6 ;; 
esac
}

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