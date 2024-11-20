function modify_lnd_dockerfile {

file="$hp/lnd/Dockerfile"
unset chip_4lnd 

cp $pn/src/lnd_docker/Dockerfile $file >/dev/null
cp $pn/src/nginx/stream_lnd.conf $hp/lnd/ >/dev/null
 
if [[ $chip == x86_64  ]] ; then chip_4lnd=amd64 ; fi
if [[ $chip == arm64   ]] ; then chip_4lnd=arm64 ; fi
if [[ $chip == armv6l  ]] ; then chip_4lnd=armv6 ; fi
if [[ $chip == armv7l  ]] ; then chip_4lnd=armv7 ; fi
if [[ $chip == aarch64 ]] ; then chip_4lnd=arm64 ; fi

if [[ -z $chip_4lnd ]] ; then
while true ; do
set_terminal ; echo -e "
########################################################################################

    Parmanode could not autodetect the$cyan chip type$orange of your system to download the 
    appropriate binary file. Please choose your chip type. If you don't know, either
    find out or guess - if you're wrong the installation will fail. Then uninstall
    and try again. Sometimes the names don't quite match up because of variations; 
    just pick the closest.

$cyan                        1)$orange amd64 (x86_64)

$cyan                        2)$orange arm64 (eg 64 bit Pi or newer Macs)     

$cyan                        3)$orange armv6l (eg some 32 bit Pis)

$cyan                        4)$orange armv7l (eg some 32 bit Pis)

$cyan                        a)$orange Abort, I'm scared. 

########################################################################################
"
choose xmpq ; read choice ; set_terminal
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P|a|A|5) return 1 ;;
1) export chip_4lnd=amd64 ; break ;;
2) export chip_4lnd=arm64 ; break ;;
3) export chip_4lnd=armv6 ; break ;;
4) export chip_4lnd=armv7 ; break ;;
*) invalid ;;
esac
done
fi

sudo gsed -i "/ENV chip_4lnd=/c\ENV chip_4lnd=$chip_4lnd" $file

}