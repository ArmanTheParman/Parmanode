function cool_stuff {
while true ; do
set_terminal_high ; echo -e "
########################################################################################
$green
                                 C O O L  S T U F F    
$orange

    DON'T MESS AROUND WITH 'SCP' - AINT NOBODY GOT TIME FOR DAT...

    Did you know, you can mount a directory on any computer on your home network, to
    the file system of your Linux computer? Even if it's a drive connected to the 
    remote computer, you can connect it to your Linux.
$cyan
        1)$orange Install sshfs    (sudo apt-get install sshfs)
$cyan
        2)$orange Create somethere on the Linux machine to mount, e.g.
$green
                mkdir ~/Desktop/remote_directory
$cyan
        3)$orange sshfs user@IP_address:/path/to/directory ~/Desktop/remote_directory $orange
        
                The above command has only 3 space-separated elements, in order
                there are the sshfs command, the remote directory, and the host
                directory where you want to mount. (In this context, 'remote'
                means other coputer, and host means the computer you're using).
$cyan
        4)$orange Use the contents of the directory as you please. If you get file permission
           issues, you can run the above command instead as:
$green
               sshfs -o uid=1000,gid=1000, user@IP_address... etc
$orange
           Replace with your own user's uid and gid, and obviously the correct paths for
           the last two elements. Get your UID/GID by typing id then <enter>.
$cyan
        5)$orange When finished, unmount the directory:
$green
            sudo umount ~/Desktop/remote_directory 
$orange
           Note it's$pink umount$orange not unmount.
    
########################################################################################
"
choose epmq ; read choice ; set_terminal
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in q|Q) exit ;; p|P) return ;; m|M) back2main ;; "") break ;; *) invalid ;; esac
done

set_terminal ; echo -e "

########################################################################################
$green
                                 C O O L  S T U F F    
$orange

    Did you know you can access the terminal of another computer using 'ssh' from your
    own terminal? Then you can completely control that computer, without getting out
    of your chair.

    type:
$cyan
        ssh usernam@IP_address
   $orange 
    Then you'll have to put the password for that username to access the computer.

    Then you should be in.

    Do what you want there, then type exit to return back to your own computer's
    terminal session.

########################################################################################
"
enter_continue ; jump $enter_cont
}
