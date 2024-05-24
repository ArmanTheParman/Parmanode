
function nostrrelay_reverse_proxy_info {

set_terminal ; echo -e "
########################################################################################
$cyan
                             Reverse Proxy - STEP 1
$orange
    Here's how to do this, and why.

    Firstly, if this relay is on your home computer, you don't want to expose its
    IP address - that's reveals your location; no good.

    Secondly, if this relay is on a VPS (virtual private server), then its location/IP
    is not that relevant, it's more about pointing a domain name to the right IP
    address - you want to use a domain NAME, not an ugly IP number that no one will
    remember or recognise.

    I recommend signign up to CloudFlare, then "add a site" to the account, and follow
    their instructions. Then set up an 'A' name under the DNS tab:

$green        Type:          A
$green        Name:          @
$green        Content:       IP address
$green        Proxy Status:  On or Off (DNS only) 
$green        TTL:           2 min

    If you turn Proxy Status off, then you don't hide the IP, but it's useful if you
    want to SSH into the computer using the domain name. If you turn proxy on, you have
    to SSH with the IP address of the server, you won't be able to use the domain.

########################################################################################
"
enter_continue
set_termianl
echo -e "
########################################################################################
$cyan
                             Reverse Proxy - STEP 2
$orange
   The next important decision is deciding if you are going to open a port on your
   server. For VPS, the ports will be open by default, move on. But for home servers,
   you would have to make a choice.

   A)    You CAN open ports on the router, both 80 (http) and 443 (https) will 
         be needed, but opening ports can be danagerous as it allows attackers outside 
         the home network access to your ports. If your passwords are not stong 
         (or if you don't have any), they can get access to your computer, but 
         not just your computer, your whole network, as the computer is connected 
         to all the others in the home via the router.

         If you choose this path, log in to your router page and forward the ports to
         the relay computer. Use the internet to learn how this is done. You then
         need to enable SSL traffic (https) by creating a certificate from a 
         certificate authority - use Let's Encrypt free service. Parmanode can do that
         for you from the menu.

   B)    Create an auto SSH tunnel from a different computer with open ports, eg a
         VPS. This requires some computer wizardy. Parmanode may have such a feature
         available when I get around to it.

########################################################################################
"
enter_continue
return
}
