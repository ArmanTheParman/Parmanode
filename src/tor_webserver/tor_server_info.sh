function tor_server_info {

set_terminal_high
echo -e "
########################################################################################
$cyan
                                Tor Web Server Information
$orange
    A Tor Web Server allows you to serve files or webpages from home via a Tor onion
    address without requiring you to open ports into your home from the internet (this
    can be a security risk). It allows you to access your files from anywhere (provided
    you know the onion address), or share files with others. It does not allow
    file uploads or access to your computer with the basic configuration used by
    Parmanode.

    Yes, this is how the Darkweb works - I do not encourage unethical activity and 
    take no responsibility for how you use this software. The intended purpose is to
    assist people in becoming self-sovereign.

    The server files are located in the$cyan /tor-server/$orange directory. 
    Please do no move this directory, as the system is specifically configured to 
    serve files from here. Moving it will break things.

    To add files to the directory, first copy or move them to$cyan /tor-server-move/  $orange
    Then come back to the tor-server menu in Parmanode, and select 
$cyan    \"move files to server\".$orange  This will move the files, and will also adjust the 
    permission settings so they will be accessible by other computers.

    The server directory starts empty. You could start by adding a file called 
    index.html which will automatically load when someone browses to your site without
    specifying a file. For other pages, the users will have to type the file name
    as part of the URL.

    If index.html doesn't exist, and the onion address without a file is accessed in
    a Tor browser, then a list of the contents of the entire directory will be 
    displayed, and sub-directories will be browsable, and files will be downloadable.
    
    If this behavious is not desirable, turn it off in the Tor-Server menu by 
    selecting$red \"Turn off file indexing.\"$orange

########################################################################################
"
enter_continue
}