#!/usr/bin/env bash

#Follow the program at $HOME/parman_programs/parmanode/src/special/do_loop.sh
#This is where the code continues, and more educational material about how this
#works is there.

source ./src/special/do_loop.sh || { echo "unable to source ./src/special/do_loop.sh" && exit ; }

exit_loop=false 

while [[ $exit_loop == false ]] ; do
exit_loop=true
do_loop $@
# upon exiting from an user initiated update, the exit_loop is set to false, so that do_loop is sourced again
# otherwise any other type of exit from do_loop will cause the whole program to end.
done

exit
