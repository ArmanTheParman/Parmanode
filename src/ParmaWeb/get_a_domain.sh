function get_a_domain {
set_terminal ; echo -e "
########################################################################################
$cyan 
                               Get a Domain Name

    1)$orange Visit a 'Domain Registrar' and buy a domain name. The dot com names are more
       expensive, but you get something cheaper like dot org, or dot net or dot me. 
       Just search for the name you want and if it's not taken, buy it. Some examples
       of domain registrars are godaddy.com, namecheap.com, squarespace.com.
$cyan
    2)$orange Open a Cloudflare.com account, and link you domain name to Cloudflare.
$cyan
    3)$orange Replace the nameservers on the Registrar site with the ones provided by
       Cloudflare.
$cyan
    4)$orange In Cloudflare, under your domain's tab, go to DNS, and add an 'A' name entry.
       Make two actually. One is to be named '@' and the other 'www'. Then, the 
       content field for each entry should be made the external IP address of your 
       computer (the router's IP), not the IP address your router gave your computer 
       (that's an internal IP). Or if you're using a VPN, put the VPN's IP address. 
       For the proxy status, I like to set it to 'DNS only', that way I can SSH into
       my computer via the domain name rather than the IP address, otherwise the proxy
       disturbs the connection. On the other hand, enabling the proxy hides your
       computer's IP address from the world.
$cyan
    5)$orange You need to wait a bit, maybe some hours, for the redirect to work. Then when 
       you navigate to your domain name, it will be redirected to your computer's 
       external IP address.
$cyan
    6)$orange Enjoy.

########################################################################################
"
enter_continue ; jump $enter_cont
}