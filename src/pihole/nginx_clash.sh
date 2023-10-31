function nginx_clash {


if ! which nginx >/dev/null 2>&1 ; then return 0 ; fi

fileNum=$(grep -rE '^\slisten.*80' /etc/nginx/* | wc -l )

if [[ $fileNum == 0 ]] ; then
set_terminal ; echo -e "
########################################################################################

    Nginx is installed on your system - this can be a problem due to port conflicts, 
    but currently it seems there is no conflict. 
    
    Please make sure you do not configure Nginx to listen on port 80, which is
    typical for a web server, and in fact, even without a webserver, just by having
    Nginx installed, it's typical for it to be listening on port 80.
    
    If there is a port clash, Nginx or PiHole won't work.
$green
                       For now, it's all good, we can continue.
$orange

########################################################################################
"
enter_continue
return 0
fi #end if fileNum == 0

while true ; do
set_terminal ; echo -e "
########################################################################################

    Parmanode has detected that NGINX is installed on your system. Nginx usually 
    listens on PORT 80 by default (the regualy http internet traffic port).

    Unfortunately, PiHole needs that port and it can't be changed. 

    You have options.

                         1)   Uninstall Nginx (Parmanode will do it)

                         2)   Stop Nginx, but don't uninstall$red (risky)$orange

                         3)   Keep Nginx, and let Parmanode guide you to change the
                              configuration file and change the port 80 
                              listening directive to 50080, freeing up port 80

                         4)$red   Abort$orange, maybe you'll make the Nginx changes yourself,
                              later, and maybe try installing PiHole later.
                         
########################################################################################
" 
choose "xpq" ; read choice
case $choice in
1)
sudo systemctl stop nginx
sudo systemctl disable nginx
sudo apt-get purge nginx
return 0 
;;
2)    
sudo systemctl stop nginx
sudo systemctl disable nginx
if ps -x | grep nginx | grep -v grep >/dev/null 2>&1 ; then
announce "Unable to stop Nginx. Aborting."
return 1
fi
announce "Do make sure to not run Nginx and PiHole at the same time or
    you will get port conflicts leading to errors."
return 0
;;

3)
#number of files with the search string...
set_terminal_high ; echo -e "
########################################################################################

    Parmanode has found the following problemaitc line(s) in Nginx configuration
    file(s):
"
grep -rE '^\slisten.*80' /etc/nginx/*

echo -e "
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

    Where you see$red '80'$orange to$green '50080'$orange. You may see the
    number 80 in other simlar looking lines, if they start with a '#' then 
    those lines are 'commeneted out' and are ignored, so no need to change them.

    You only need to find the pattern of text listed above and modify those.

    When done, if you've been successful, running the PiHole installation again
    will bypass this prompt.
$pink
    You must restart Nginx for the changes to take effect.
$orange
########################################################################################
"
enter_continue
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