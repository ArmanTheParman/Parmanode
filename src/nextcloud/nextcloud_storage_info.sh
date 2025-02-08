function nextcloud_storage_info {

set_terminal_high ; echo -e "
########################################################################################
    
    The easiest way to store your NextCloud data to a different location to the
    standard docker location$cyan /var/lib/docker$orange is to do this...

        1) Make a new directory wherever you want (eg external drive)

        2) Stop Docker:$cyan sudo service docker stop $orange and double check that
           no containers are running.

        3) Edit the file (or make new)$cyan /etc/docker/daemon.json$cyan and include
           this json block:$pink

           {
               "data-root": "/path/to/your/docker" 
           }$orange
        
        4) Move the existing Docker contents to the new location, and delete the
           old directory
        
        5) Restart Docker:$cyan sudo service docker start $orange

$green
    Finally, to keep your data safe, you might want to have a second copy. See
    the Rsync help tool in Parmanode menu, to synchronise your data storage to a
    backup drive.
$orange
########################################################################################
"
enter_continue ; jump $enter_cont

}