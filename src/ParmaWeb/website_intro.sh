function website_intro {
while true ; do
set_terminal_custom 50 ; echo -e "
########################################################################################
$cyan
                                   P A R M A W E B
$orange 
    ParmaWeb is s tool to help you install a$green WordPress Server$orange from home or your VPS in
    an easy AF way.

    Although Parmanode is Free Open Source Software, ParmaWeb is an add-on and is
$red    not free$orange. You are free to try it, read the code, learn from it, but to USE it, 
    the conditions are that you pay$green 75,000 sats$orange (once), if you can afford it, 
    using this donation page:
$bright_blue
        https://armantheparman.com/donations
$orange
    It's OK, I'm not going to hunt you down if you don't pay; honesty system.

    FYI, WordPress Servers are also known as LAMP or LEMP servers, and they're damn
    hard to install... I've made it easy for you though.

    LEMP stands for '${green}L${orange}inux, Nginx (prounounced ${green}E${orange}ngine X), ${green}M${orange}aria DB 
    (a fork of MySQL relational database software), ${green}P${orange}HP (a programming language). 
    LAMP is similar, except Apache is used instead of Nginx.
    
    The above programs will be installed for you if they are not yet already, ports
    will be configured, the database will be set up, and the wordpress.org software 
    will be installed. You can then log in to Wordpress on your computer, and make 
    edits to your website (info will be in the Parmanode menu).

    You also have menu options to connect a domain name, set up SSL certificates for
    https access, backup the database to a file, and generate access over 
    Tor (Darkweb). There is also educational material available in the menu.

    Continue? $green

            y)          Yeah, this is great 
$red              
            n)          Nah, maybe later, too good to be true
$orange

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in q|Q) exit 0 ;; p|P|n|N) return 1 ;; y|Y|yes) return 0 ;; *) invalid ;; esac
done
}