
function website_info {
source $pc
set_terminal ; echo -e "
########################################################################################
$cyan
                                  Website Info 
$orange 
    So you've decided to host your own webiste. Noice. Here's what you need to know...
    
    Parmanode has installed Wordpress.org for you. Amazing huh? It's a 'what-you-see-
    is-what-you-get' website editor. You use it to create pages for your website from
    within a browser, and the data is stored in a MariaDB database (MariaDB is a 
    MySQL open source fork).

    You'll create your account the first time you navigate to your computer's IP:
    
        http://$domain_name/myphpadmin
    
    Then you can start building your website using the Wordpress tools.

    The website won't be available to the world automatically though. There's more to 
    do.

    The website is being served on port 80. That means anything connecting to your
    computer's IP and requesting port 80 (standard web port), either a program (eg 
    browser) from the computer itself, or a browser from another computer, wil be
    served the website that you built.

    HOWEVER, by default, the outside world is blocked from accessing port 80...

########################################################################################
"
enter_cotinue
set_terminal ; echo -e "
########################################################################################

    Here's what's going on:

    Your home's internet connection has an 'external' IP address. This is the address
    that other computers on the internet need to request in order to reach your home.
    This address is public.

    The traffic from the internet goes to that IP and to your router (you can think
    of it as your router's IP). The router manages the internal IP addresses of all
    the connected devices on your home network. It gives addesses like

    192.168.0.100 or 192.168.0.174

    to any connected device. The first part of the number is consistent, and the last
    part is between 0 and 255. Actually, the router's internal IP address usually ends
    in 1. 

    For your computer, when it surfs the internet, data goes from the computer, to
    the router, then to some ISP exchange, then various hops across the globe to
    the desination IP. Eg, for Google, the IP is 8.8.8.8.

    Your network's IP address is $external_IP

    The rest of the network can see it, but they can not get inside; your router
    blocks traffic. It will only allow data in if your computer specifically connectec
    to an external computer and is receiving a response...

########################################################################################
"
enter_coninue
set_terminal ; echo -e "
########################################################################################

    If you want to be a server, ie host a website, you have to manually tweak your
    router and allow ports to be opened to the world. For regular non-encrypted
    internet traffic (http), you need to open port 80. For SSL encrypted traffic 
    (https), you need to open port 443.

    There are some risks to opening ports. I do not know how to exploit this setup
    myself so I can't give much advice about these risk, but it is necessary to do this
    if you want to host a regular website.

    The alternative is to host a website on a Virtual Private Server (VPS), or you
    can serve your website via the Darknet (Tor). This is safer as it's not required
    for ports to be opened, but your website will not be as visible or searchable.
    People will have to be given the onion address to reach it.

    To open ports, you'll need to read the manual of your router, or search online
    about your sepecific hardware, or ask ChatGPT.

    Once it's opened, you can direct your domain name from a DNS server (like
    CloudFlare) to your router's (external) IP address. From there, port forwarding
    rules on the router will take port 80 traffic and direct it (according to your
    instructions) to the appropriate machine on your home network. Once the request
    reaches your server's computer, the computer (well Nginx software actually) 
    which is listening specifically for port 80 traffic will serve information
    from the appropriate directory (/var/www/website/).

########################################################################################
"
enter_continue
return 0
}