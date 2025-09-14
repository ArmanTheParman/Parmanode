function X11_preamble {
while true ; do
set_terminal_high ; echo -e "
########################################################################################$cyan
                                 X11  Forwarding$orange
########################################################################################

    X11 forwarding allows you to SSH log in to a$cyan REMOTE$orange machine and have programs 
    with a Graphical User Interface (GUI) running on there to display on the$cyan CLIENT $orange 
    machine (the 'from' machine).

    For it to work, on the remote machine, you need these settings enabled in the 
    sshd_config file...$green

        X11Forwarding yes

        X11DisplayOffset 10 $orange
    
    Of course, Parmanode is going to take care of that for you.

    Also, on the client machine, you need XQuartz running if you're on a Mac. For Linux
    it'll just work without XQuartz (because Linux is far superior). Just leave 
    XQuartz running in the background and user the terminal to do your remote log in, 
    but you can also use XQuartz's own terminal.

    To install XQuartz on a Mac, run this command in a Terminal window...
$cyan
        curl https://parman.org/install_xquartz.sh | sh $orange

    When doing SSH, on the client machine, you just need to add a$pink -X$orange when you log 
    in for it to work. For example... $green

        ssh -X parman@parmanodl.local
$orange 
    Then, if you open say a wallet program, the GUI will pop up on the client machine.
    Bloody cool huh??

    Just hit$cyan <enter>$orange to enable, otherwise$red p$orange will get you out of here.

########################################################################################
"
read choice
jump $choice || { invalid ; continue ; }
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
"") break ;;
*) invalid ;;
esac
done
}