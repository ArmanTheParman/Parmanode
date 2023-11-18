function test_directory_placement {
cd .. #moves one directory up the tree
testing_dir=$(pwd) #places the output of the command, pwd, into a variable
cd - >/dev/null # "cd - " means go back to the directory before, whatever it was
# >/dev/null ; this means redirect the output (>) to a file called /dev/null, 
# which is a discard file


# Note that = assigns values and == compares values
# as in = says "make the left side equal the right side"
# and == says check if the left side is the same as the right side
if [[ $testing_dir == "$HOME" ]] ; then #if so then bad news, directory is in the wrong place. 
# Also $HOME is going to be different for everyon's computer. On Linux, it is /home/username.
# on Macs it's /Users/username/
test_directory_placement_message #see below for function details
fi

#in case directory is nested and $HOME/parmanode is part of the path. Not ok.
if pwd >/dev/null | grep "$HOME/parmanode" ; then #if the result of pwd (which will not 
#be printed because of >/dev/null) when grep'ed (a search function) includes
#"$HOME/parmanode", then do the function below
test_directory_placement_message2
fi
}

function test_directory_placement_message {

clear ; echo "
########################################################################################

    Parmanode needs to live at $HOME/parman_programs/parmanode/ to run properly.

    Do you want to have that fixed now?

              y)      Do it (you'll need to then restart Parmanode) 

              n)      Nah (ok, but Parmanode won't run)
    
########################################################################################
"
read choice

case $choice in

y|Y|Yes|YES|yes)
announce "The directory $original_dir will be moved to 
    $HOME/parman_programs/parmanode" "OK? Hit Control-C now to cancel and quit" 
cd ; mkdir -p parman_programs ; mv $original_dir $HOME/parman_programs/
set_terminal
exit 0 
;;
*)
set_terminal
exit 0
;;
esac

#enter_continue is a custom function I made which prints something and prompts the user
#to hit enter, using the read command.
#&& means to run the second command only if the first command runds successfully. It's
#kind of unneccesary here, but doesn't matter.
}

function test_directory_placement_message2 {

clear ; echo "
########################################################################################

    Oh dear, you've downloaded the Parmanode software in a subdirectory of
	$HOME/parmanode 

    Parmanode needs to live at $HOME/parman_programs/parmanode/ to run properly.

    Do you want to have that set up now?

              y)      Do it (you'll need to then restart Parmanode) 

              n)      Nah (ok, but Parmanode won't run)

########################################################################################
"
case $choice in

y|Y|Yes|YES|yes)
announce "The directory $original_dir will be moved to 
    $HOME/parman_programs/parmanode" "OK? Hit Control-C now to cancel and quit" 
cd ; mkdir -p parman_programs ; mv $original_dir $HOME/parman_programs/set_terminal
exit 0 
;;
*)
exit 0
;;
esac
}
