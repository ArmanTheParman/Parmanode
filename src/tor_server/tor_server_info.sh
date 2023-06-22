unction tor_server_info {

set_terminal_high
echo "
########################################################################################

                                Tor Server Information

    A Tor server allows you to serve files or webpages from home via a Tor onion
    address without requiring you to open ports into your home from the internet (this
    can be a security risk). It allows you to access your files from anywhere (provided
    you know the onion address), or share files with others. It does not allow
    file uploads or access to your computer with the basic configuration used by
    Parmanode.

    Yes, this is how the darkweb works - I do not encourage unethical activity and 
    take no responsibility for how you use this software. The intended purpose is to
    assist people in becoming self-sovereign.

    The server files are located in the /tor-server/ directory. Please do no move this
    directory, the system is specifically configured to serve files from here. Moving
    it will break things.

    To add files to the directory, first copy or move them to /tor-server-move/  
    
    Then come back to the tor-server menu in Parmanode, and select 
    \"move files to server\".  This will move the files and also correct the 
    permissions so they will be accessible.

    The server directory starts empty. You could start by adding a file called 
    index.html which will automatically load when someone browses to your site without
    specifying a file.

    If index.html doesn't exist, and the onion address without a file is accessed in
    a Tor browser, then the contents of the entire directory will be displayed, and
    sub-directories will be browsable, and files will be downloadable.
    
    If this behavious is not desirable, turn it off in the Tor-Server menu by 
    selecting \"Turn off file indexing.\"

########################################################################################
"
enter_continue
}