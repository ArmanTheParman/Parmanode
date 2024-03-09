function website_intro {
while true ; do
set_terminal ; echo -e "
########################################################################################

    Parmanode will help you install a$cyan LEMP stack$orange so you can host your website
    in an easy AF way.

    LEMP stands for '${green}L${orange}inux, Nginx (prounounced ${green}E${orange}ngine X), ${green}M${orange}aria DB (a fork of MySQL 
    relational database software), ${green}P${orange}HP (a programming language). 
    
    The above programs will be installed for you if they are not yet already, ports
    will be configured, and the wordpress.org software will be installed. You can then
    log in to wordpress on your computer, and make edits to your website.

    Assistance with domain name configuration is part of this too.

    Continue? $green

            y)          Yeah, this is great. Why is it free?   $orange (... IDK, I'm crazy)
$red              
            n)          Nah, maybe later, too good to be true.
$orange
########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in q|Q) exit 0 ;; p|P|n|N) return 1 ;; y|Y|yes) return 0 ;; *) invalid ;; esac
done
}