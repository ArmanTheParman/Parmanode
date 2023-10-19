function ParmanodL_success {

set_terminal_higher ; echo -e "
########################################################################################

                                  S U C C E S S !! 

$pink
    PLEASE READ THIS CAREFULLY...
$orange 
1   The microSD card should be ready to remove and put into your Pi. Attach the Pi
    to an internet connection with an ethernet cable, and then power it on.

2   Give it a minute or two to boot up silently.

3   When you want to use Parmanode to run Bitcoin, you'll need an external SSD hard 
    drive - One terabyte is recommended.

4   If you want a desktop environment for the Pi, attach a monitor and
    keyboard - it'll work nice.

5   You can SSH into the Pi by typing this in any computer's terminal on the same
    home network as the Pi:
	
	$cyan        ssh parman@parmanodl.local $orange

    Hit <enter> afterwards, of course.

6   The most user-friendly way is to double-click the run_parmanodl icon that has
    been placed on your desktop. This script ensures how to handle certain
    communication errors with SSH keys.

7   The password for the ParmanodL is$green "parmanodl" $orange

    Enjoy.						

########################################################################################
"
enter_continue
set_terminal ; echo -e "
########################################################################################

     I'M SURE YOU DIDN'T READ THAT PROPERLY. NOTE, THE PASSWORD IS:
$cyan         
                parmanodl
$orange
     NOT parmanode, but parmanodl.

########################################################################################    
"
enter_continue
set_terminal
}