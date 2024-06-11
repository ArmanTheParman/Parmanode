function nextcloud_storage_info {

set_terminal_high ; echo -e "
########################################################################################

    I tried really hard to make it easy to give you options to choose where to 
    store your NextCloud data.

    NextCloud has pesky requirements so this is the best solution I came up with
    for now...

    Normally, docker volumes are to be found here...
$cyan
       /var/lib/docker/volumes/ $orange 

    I suggest that if you want to store NextCloud data on an external drive, it's 
    safest to adjust settings yourself. This is generally how...

        1)    Install NextCloud with Parmanode
        2)    Stop the containers (use Parmanode menu)
        3)    Prepare your external drive
        4)    Move the above directory to your external drive, with its subdiretory 
              structure and permissions in tact (this moves all docker volumes you
              may be running, but that's probably fine).
        5)    Create a simlink from the now missing path to the new location. The
              command for this is...
$cyan
    sudo ln -s$green <full path to target directory>$cyan /var/lib/docker/volumes
$orange
        6)    Restart the container
        7)    Test the container started properly, add some data using NextCloud GUI, 
              and see if it has successfully been stored on the external drive before 
              putting crucial files in there.        
$green
    Finally, to keep your data safe, you might want to have a second copy. See
    the Rsync help tool in Parmanode menu, to synchronise your data storage to a
    backup drive.
$orange
########################################################################################
"
enter_continue

}