function menu_pihole {
while true ; do 

if docker ps | grep -q pihole ; then
local piholerunning="Running"
else
local piholerunning="Not Running"
fi

set_terminal ; echo -e "
########################################################################################
                 $cyan               PiHole Menu            $orange                   
########################################################################################

                          Your PiHole is$pink $piholerunning$orange


         (start)                Start PiHole 

         (stop)                 Stop PiHole

         (pp)                   Make new password for web interface login

         (i)                    Important information

         (ub)                   Enable Unbound (Personal upstream DNS server)

         (ubx)                  Disable Unbound

    To access PiHole, navigate to$green $IP/admin/
$orange
########################################################################################
"


choose "xpmq" ; read choice ; set_terminal
case $choice in 
m|M) back2main ;;
q|Q|QUIT|Quit) exit 0 ;;
p|P) menu_use ;; 
start|Start|START|S|s)
start_pihole
;;

stop|Stop|STOP)
stop_pihole ;;

i|I|info|Info)
info_pihole
return 0 ;;

ub|UB)
enable_unbound ;;
ubx|UBX)
disable_unbound ;;

pp)
clear
echo -e "Please enter new password then hit <enter>. You will only be asked once.

"
read piholepassword
docker exec -it pihole /bin/bash -c "pihole -a -p $piholepassword" 
debug "look"
success "Your PiHole password has been set" ;;
*)
invalid
;;

esac
done
} 


function enable_unbound {

if [[ $OS == Mac ]] ; then no_mac ; return 1 ; fi

while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                          UNBOUND RECURSIVE DNS RESOLVER
$orange
    Unbound is your personal upstream DNS resolver. Pi Hole is the DNS serve, but
    mainly is to filter ads. When you request a Domain name that Pi Hole is unaware
    of, it sends a request to a public DNS resolver, like Google or OpenDNS.

    This is not great for privacy. With Unbound as the DNS resolver, your instance
    will get the domain names not from one location, but in a distributed fashion.

    This way, no profile on what your browse is built up.

    Parmanode will install unbound, then make the necessary modifications to the 
    PiHole configuration files.

    Proceed?
$green
                          y)        Yeah, do it.
$red
                          n)        Nah, what's the point?
$orange
########################################################################################
"
choose "xpqm" ; read choice
case $choice in
q|Q) exit 0 ;; n|N|NO|no|p|P) return 1 ;; m|M) back2main ;; y|Y|YES|Yes|yes) break ;; *) invalid ;; esac
done

if ! which unbound >/dev/null 2>&1 ; then
sudo apt-get update -y
sudo apt-get install unbound -y
else
sudo systemctl enable unbound
sudo systemctl start unbound
fi


sudo cat << EOF | sudo tee /etc/unbound/unbound.conf.d/pi-hole.conf 
server:
    # If no logfile is specified, syslog is used
    # logfile: "/var/log/unbound/unbound.log"
    verbosity: 0

    interface: 127.0.0.1
    port: 5335
    do-ip4: yes
    do-udp: yes
    do-tcp: yes

    # May be set to yes if you have IPv6 connectivity
    do-ip6: no

    # You want to leave this to no unless you have *native* IPv6. With 6to4 and
    # Terredo tunnels your web browser should favor IPv4 for the same reasons
    prefer-ip6: no

    # Use this only when you downloaded the list of primary root servers!
    # If you use the default dns-root-data package, unbound will find it automatically
    #root-hints: "/var/lib/unbound/root.hints"

    # Trust glue only if it is within the server's authority
    harden-glue: yes

    # Require DNSSEC data for trust-anchored zones, if such data is absent, the zone becomes BOGUS
    harden-dnssec-stripped: yes

    # Don't use Capitalization randomization as it known to cause DNSSEC issues sometimes
    # see https://discourse.pi-hole.net/t/unbound-stubby-or-dnscrypt-proxy/9378 for further details
    use-caps-for-id: no

    # Reduce EDNS reassembly buffer size.
    # IP fragmentation is unreliable on the Internet today, and can cause
    # transmission failures when large DNS messages are sent via UDP. Even
    # when fragmentation does work, it may not be secure; it is theoretically
    # possible to spoof parts of a fragmented DNS message, without easy
    # detection at the receiving end. Recently, there was an excellent study
    # >>> Defragmenting DNS - Determining the optimal maximum UDP response size for DNS <<<
    # by Axel Koolhaas, and Tjeerd Slokker (https://indico.dns-oarc.net/event/36/contributions/776/)
    # in collaboration with NLnet Labs explored DNS using real world data from the
    # the RIPE Atlas probes and the researchers suggested different values for
    # IPv4 and IPv6 and in different scenarios. They advise that servers should
    # be configured to limit DNS messages sent over UDP to a size that will not
    # trigger fragmentation on typical network links. DNS servers can switch
    # from UDP to TCP when a DNS response is too big to fit in this limited
    # buffer size. This value has also been suggested in DNS Flag Day 2020.
    edns-buffer-size: 1232

    # Perform prefetching of close to expired message cache entries
    # This only applies to domains that have been frequently queried
    prefetch: yes

    # One thread should be sufficient, can be increased on beefy machines. In reality for most users running on small networks or on a single machine, it should be unnecessary to seek performance enhancement by increasing num-threads above 1.
    num-threads: 1

    # Ensure kernel buffer is large enough to not lose messages in traffic spikes
    so-rcvbuf: 1m

    # Ensure privacy of local IP ranges
    private-address: 192.168.0.0/16
    private-address: 169.254.0.0/16
    private-address: 172.16.0.0/12
    private-address: 10.0.0.0/8
    private-address: fd00::/8
    private-address: fe80::/10
EOF
debug "pause"
sudo systemctl restart unbound >/dev/null 2>&1

docker exec -itu root pihole /bin/bash -c "sed -i '/PIHOLE_DNS_/d/' /etc/pihole/setupVars.conf"
debug "deleted?"
docker exec -itu root pihole /bin/bash -c "echo 'PIHOLE_DNS_1=127.0.0.1#5335' >> '/etc/pihole/setupVars.conf' "
success "Unbound DNS Resolver" "being configured"
}

function disable_unbound {

sudo systemctl stop unbound
sudo systemctl disable unbound

docker exec -itu root pihole /bin/bash -c "sed -i '/PIHOLE_DNS_/d/' /etc/pihole/setupVars.conf"
debug "deleted"
docker exec -itu root pihole /bin/bash -c "echo 'PIHOLE_DNS_1=8.8.8.8' >> '/etc/pihole/setupVars.conf' "
success "Unbound DNS Resolver" "being disabled"
}