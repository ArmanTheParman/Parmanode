function nextcloud_storage_info {

set_terminal_high ; echo -e "$blue
########################################################################################
    
    The easiest way to store your NextCloud data to a different location to the
    standard docker location$orange /var/lib/docker$blue is to do this...

        1) Make a new directory wherever you want (eg external drive)

        2) Stop Docker:$orange sudo service docker stop $blue and double check that
           no containers are running.

        3) Edit the file (or make new)$orange /etc/docker/daemon.json$blue and include
           this json block:$pink

           {
               "data-root": "/path/to/your/docker" 
           }$blue
        
        4) Move the existing Docker contents to the new location, and delete the
           old directory$orange

               sudo rsync -aP /source/ /destination/
               sudo rm -rf /old$blue
        
        5) Restart Docker:$orange 

               sudo service docker start $blue 

           Or, reboot.

$green
    Finally, to keep your data safe, you might want to have a second copy. See
    the Rsync help tool in Parmanode menu, to synchronise your data storage to a
    backup drive.
$blue
########################################################################################
"
enter_continue ; jump $enter_cont

}