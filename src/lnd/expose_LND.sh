function expose_LND {

get_extIP >/dev/null

set_terminal ; echo -e "
########################################################################################
  
    You'll be able to find other nodes and make peer connections, and open channels,
    but in order for OTHER nodes to find you and make peer connections, you need to
    either run LND behind TOR (asy from Parmanode menu), or if using clearnet, expose 
    your exteral IP (done manually, can be tricky). 
    
    Note, the internal IP address your router has given this computer (and all other
    devices connected to the router on the home network) is a totally different thing
    to the external IP address. The internal IP is not accessible from computers 
    outside your home. 
   
    The external IP is the IP address OF THE ROUTER itself, where all internet traffic 
    first goes to before reaching your computer. 

    Parmanode has detect your external IP - it is:
    
                               $extIP
    
    ... and it has been entered into the lnd configuration file. But unless you tell 
    the router to allow traffic from the internet to access your node, other nodes 
    won't be able to find you.

    Here's how ...

########################################################################################
"
enter_continue

clear
echo -e "
########################################################################################

    Parmanode can't do this for you, sorry, but here are the instructions:

    Log into the web server of your router using BROWSER by typing in your router's
    INTERNAL IP address. The address is likely to be something like:
$cyan
        192.168.0.1    or    10.0.0.1
$orange
    These IP address are very common and not secret. My computer's is 192.168.0.1, 
    and no one can access it unless they get passed my router's external IP and 
    firewall.

    You could try looking up the router's manuel for its internal IP address. Once you
    log in, you should be able to see the router's EXTERNAL IP, and the internal IPs
    of all the connectd devices.

    Somewhere on the page, perhaps under advanced settings, you should see a way
    to add \"port forwarding\".

    Create a new IPv4 port forwarding rule; name it anything; choose TCP for the 
    protocol; make the WAN and LAN port options 9735; and put the destination IP the
    same as this computer's: $IP 

    Then save, and restart LND. 

########################################################################################
"
enter_continue
return 
}