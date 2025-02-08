#!/usr/bin/env bash 

#This is where the code begins. Educational comments will be included as well, not
#just comments for developers.

#In Bash script, one the first line and first character, the # is treated specially. 
#It must the very first character in a file followed by !, then the path to the terminal program. 
#In every other place (outside of quotes), # will cause the text on the right to be treated as a 
#comment and not code.

#soucing executes files, and loads functions to the memory, making them available to the program
source $HOME/parman_programs/parmanode/src/special/do_loop.sh || {
    echo "Unable to source $HOME/parman_programs/parmanode/src/special/do_loop.sh" >&2
    exit 1 
    }
#an error signal returns a non-zero value to the or operator ||, from the left-hand side, and
#triggers execution of the code on the right-hand side.

# if run_parmanode.sh is run with an argument x, eg "rp x" or
#"$HOME/parman_programs/run_parmanode.sh x", then very detailed debugging output is turned on.
#This is not for the end user.
if [[ $1 == x ]]; then
    set -x
    echo "Debug mode enabled (set -x)."
fi
#"enter_continue" is a custom function. You can search for that function with the string:
#"enter_continue {" which will only ever occur where the function is defined. Because all the
#scripts have been sourced, the function is in the memory and 'enter_continue' can be called
#as above. Strings after a function call are arguments to the function. Here enter_continue
#takes the string and uses it in the print output.
#Also of note, $ indicates variables. The $ and then a number indicate the nth stings that 
#is passed to the function as arguments.

#set a variable to mimic a "do while loop - ie run once regardless, then check the loop condition
#before deciding to run again
exit_loop=1  # 1 = false, 0 = true

while [[ $exit_loop -eq 1 ]]; do
    # Immediately change the variable to prevent automatic repetition.
    exit_loop=0

# Upon exiting from a user-initiated update, the exit_loop is set to false, so that do_loop is sourced again
# otherwise any other type of exit from do_loop will cause the whole program to end.
# the sourcing of all the other functions is not repeated, because depending on the update details
# old version of functions, eg if there is renaming involved, won't necessary delete functions from
# memory, it will only update to a newer version. It's safer to competely exit the program and return
# after an update.

#Follow the program execution at $HOME/parman_programs/parmanode/src/special/do_loop.sh
#This is where the code continues, and more educational material about how it works is there.
do_loop "$@"
#The $@ is a variable that holds all the arguments passed to the function. So if there are multiple
#arguments passed to run_parmanode, then all those arguments are passed to do_loop this way.
done

exit 0
