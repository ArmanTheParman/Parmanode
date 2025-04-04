function nginx_clash {

if [[ $1 == public_pool_ui ]] ; then
set_terminal ; echo -e "
########################################################################################

    There is an Nginx error. Public_Pool needs Nginx to configure SSL traffic to 
    your machine, but there is a port 80 conflict. Aborting.

########################################################################################
"
enter_continue ; jump $enter_cont
return 1
fi


if [[ $OS == Mac ]] ; then local nginxDir="/usr/local/etc/nginx" ; fi
if [[ $OS == Linux ]] ; then local nginxDir="/etc/nginx" ; fi

if ! sudo which nginx >$dn 2>&1 ; then return 0 ; fi

fileNum=$(grep -rE '^\slisten.*\s+80\s+' $nginxDir/* | wc -l )

if [[ $fileNum == 0 ]] ; then
set_terminal ; echo -e "
########################################################################################

    Nginx is installed on your system - this can be a problem due to port conflicts, 
    but currently it seems$green there are no conflicts$orange. 
    
    Please make sure you do not configure Nginx to listen on port 80, which is
    typical for a web server, and in fact, even without a webserver, just by having
    Nginx installed, it's typical for it to be listening on port 80.
    
    If there is a port clash, Nginx won't work.
$green

                       For now, it's all good, we can continue.
$orange

########################################################################################
"
enter_continue ; jump $enter_cont
return 0
fi #end if fileNum == 0

while true ; do
set_terminal ; echo -e "
########################################################################################

    Parmanode has detected that NGINX is installed on your system. Nginx usually 
    listens on PORT 80 by default (the regular http internet traffic port).

    Unfortunately, $1 needs that port and it can't be changed. 

    You have options.

                         1)   Uninstall Nginx (Parmanode will do it)

                         2)   Stop Nginx, but don't uninstall$red (risky)$orange

                         3)   Keep Nginx, and let Parmanode guide you to change the
                              configuration file and change the port 80 
                              listening directive to 50080, freeing up port 80

                         4)$red   Abort$orange, maybe you'll make the Nginx changes yourself,
                              later, and maybe try installing $1 later.
                         
########################################################################################
" 
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
1)
if [[ $OS == Linux ]] ; then
sudo systemctl stop nginx
sudo systemctl disable nginx
sudo apt-get purge nginx
fi

if [[ $OS == Mac ]] ; then
if which brew >$dn ; then
    clear ; please_wait
    brew stop nginx 
    brew services uninstall nginx >$dn 2>&1
    rm -rf /usr/local/etc/nginx/
    rm -rf /usr/local/var/log/nginx/
    cd ; brew cleanup
else
    set_terminal
    announce "Parmanode detected that Nginx is not installed with Homebrew Package manager.
    It cannot uninstall Nginx for you. Please do this yourself and try the installation
    again. Aborting."
    return 1
fi
fi

return 0 
;;
2)    
if [[ $OS == Linux ]] ; then
sudo systemctl stop nginx
sudo systemctl disable nginx
    if ps -x | grep nginx | grep -v grep >$dn 2>&1 ; then
    announce "Unable to stop Nginx. Aborting."
    return 1
    fi
fi

if [[ $OS == Mac ]] ; then
please_wait
brew services stop nginx
    if ps -x | grep nginx | grep -v grep >$dn 2>&1 ; then
    announce "Unable to stop Nginx. Aborting."
    return 1
    fi
fi

announce "Do make sure to not run Nginx and $1 at the same time or
    you will get port conflicts leading to errors."
return 0
;;

3)
#number of files with the search string...
set_terminal_high ; echo -e "
########################################################################################

    Parmanode has found the following problemaitc line(s) in Nginx configuration
    file(s):
$cyan"
grep -rE '^\slisten.*\s+80\s+' $nginxDir/*
grep -rE '^\slisten.*\s+80\s+' $nginxDir/*


echo -e "$orange
    The file name is in the left column, and the offending text found in that file is
    on the same row in the right column.

    I have chosen to not make programmed edits to these files for fear of causing
    unexpected errors. You can back these files up and then make the necessary edits
    with guidance below.

    Open a new terminal to make edits to these files. You can use the command:

        sudo nano /file/in/question
    
    After changing the text (see below how to change), save the file by hitting 
    control-x, then y to agree to save, then <enter> to exit without changing the 
    filename.

    Where you see$red '80'$orange, change it to$green '50080'$orange. You may see the
    number 80 in other simlar looking lines, but if those lines start with a '#',
    then those lines are 'commeneted out' and are ignored, so no need to change them.

    You only need to find the pattern of text listed above and modify those.

    When done, if you've been successful, running the $ installation 
    again will bypass this prompt.
$pink
    You must restart Nginx for the changes to take effect.
$orange
########################################################################################
"
enter_continue ; jump $enter_cont
return 1
;;
4) 
return 1 
;;
*) invalid
;;
esac
done
    
}