#!/bin/bash

# source all the  modules.

	for file in ./src/**/*.sh
	do
	source $file
	done


# Check OS function and store in variable for later. Exits if Windows, or if not if Mac/Linux not detected.

	which_os

# set "trap" conditions; currently makes sure user's terminal reverts to default colours.

	clean_exit 

# Debug - comment out before release.

#     debug_point "Pause here to check for error output before clear screen." 



#Begin program:

	set_terminal # custom function for screen size and colour.
	intro
	startup

exit 0
