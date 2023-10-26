function parmashell_info {

set_terminal ; echo -e "
########################################################################################
$cyan
                              ParmaShell Information

$orange                         
    Here's some cool things you can do in terminal when ParmaShell is installed.

    - Keyboard shortcuts have been created with speed in mind. Start using them and
      soon you'll get faster.
    - Refresh/clear the screen anytime with$green \"a\"$orange and <enter>
    - The default size of the screen is a bit bigger 
    - The contents of the directory is shown at the top, in colour, and the
      current working directory printed in full.
    - If its too cluttered with a refresh, just type$cyan \"st\"$orange (set terminal), and 
      the screen will be refreshed without the directory contents. 

    -$cyan \"aa\"$orange give a printout of \"ls -lah\" in colour and refreshes screen 
    -$cyan \"..\"$orange an existing command but now combined with$cyan a$orange commande. You'll
    -$cyan \"d\"$orange  changes directory to Desktop, and refreshes
    -$cyan \"dl\"$orange changes to Downloads directory, and refrehes
    -$cyan \"pn\"$orange changes to the Parmanode script driectory
    -$cyan \"pp\"$orange changes to parman_programs directory
    -$cyan \"hp\"$orange stands for 'home parmanode' and changes to the parmanode apps directory
    -$cyan \"h\" $orange change directory to home

   This list will grow as I think of good ideas. Requests welcome. 

   See file $pn/src/ParmaShell/parmashell_functions for function
   definitions and names.

########################################################################################
"
enter_continue
}