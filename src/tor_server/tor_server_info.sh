function tor_server_info {

set_terminal
echo "
########################################################################################
                                Tor Server Information

    The server files are located in /tor-server/ directory. Please do no move this
    directory, the system is specifically configured to serve files from here. Moving
    it will break things.

    To add files to the directory, first copy or move them to /tor-server-move/  
    
    Then come back to the Tor-Server menu in Parmanode, and select 
    \"move files to server\". This will move the files and also correct the 
    permissions so they will be accessible.

    The server directory starts empty. You can create add a file called index.html,
    then add it to /tor-server-move/ . After it gets moved to /tor-server/ , this
    file will automatically load when someone browses to your site without needing to
    specify a specific page; index.html will just load.

    If index.html doesn't exist, and the onion address without a file is accessed in
    a Tor browser, then the contents of the entire directory will be displayed,
    allowing one to click and download. If this behavious is not desirable, turn it 
    off in the Tor-Server menu by selecting \"Turn off file indexing.\"

    Do be aware that the onion address alone is not enough to access your server. The
    port number, 7001, must also be specified. Immediately after the \".onion\" part 
    of the address, add \":\" and then \"7001\".

########################################################################################
"
enter_continue
}