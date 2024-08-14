function tor_server_info {

set_terminal_high
echo -e "
########################################################################################
$cyan
                              Tor Web Server Information
$orange
########################################################################################

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

    To add files to your server, just copy files there, then combe back to the 
    Parmanode Tor Web Server menu, and select 'set permissions', otherwise the files
    will not be accessible.

    The server directory starts empty. You could start by adding a file called 
    ${cyan}index.html$orange which will automatically load when someone browses to your site without
    specifying a file. For other pages, the users will have to type the file name
    as part of the URL to access the file.

    If you turn indexing on in the Parmanode menu, then if a user searches your
    onion address without specifying a page, then they can see the contents of the
    server directory - that's up to you to allow or not.
    
########################################################################################
"
enter_continue
}