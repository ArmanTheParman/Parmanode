function cool_stuff {

set_terminal_high ; echo -e "

########################################################################################
$green
                                 C O O L  S T U F F    
$orange

    DON'T MESS AROUND WITH 'SCP' - AINT NOBODY GOT TIME FOR DAT...

    Did you know, you can mount a directory on any computer on your home network, to
    the file system of your Linux computer? Even if it's a drive connected to the 
    remote computer, you can connect it to your Linux.

        1) Insall sshfs    ({$cyan}sudo apt-get install sshfs$orange)

        2) Create somethere on the Linux machine to mount, e.g.
$cyan
                mkdir ~/Desktop/remote_directory
$orange        
        3)$cyan sshfs user@IP_address:/path/to/directory ~/Desktop/remote_directory $orange
        
                The above command has only 3 space-seperated elements, in order
                there are the sshfs command, the remote directory, and the host
                directory where you want to mount. (In this context, 'remote'
                means other coputer, and host means the computer you're using).

        4) Use the contents of the directory as you please. If you get file permission
           issues, you can run the above command instead as:
$cyan
               sshfs -o uid=1000,gid=1000, user@IP_address... etc
$orange
           Replace with your own user's uid and gid, and obviously the correct paths for
           the last two elements. Get your UID/GID by typing id then <enter>.

        5) When finished, unmount the directory:
$cyan
            sudo umount ~/Desktop/remote_directory 
$orange
           Note it's$pink umount$orange not unmount.
    
########################################################################################
"
ecrm
if [[ $ecrm == rm ]] ; then unset ecrm ; return 0 ; fi

set_terminal ; echo -e "

########################################################################################
$green
                                 C O O L  S T U F F    
$orange

    Did you know you can access the terminal of another computer using 'ssh' from your
    own terminal? Then you can completely control that computer, without getting out
    of your chair.

    type:

        ssh usernam@IP_address
    
    Then you'll have to put the password for that username to access the computer.

    Then you should be in.

    Do what you want there, then type exit to return back to your own computer's
    terminal session.

########################################################################################
"
enter_continue
}
