
# Check OS function and store in variable for later.

	OS=$(which_os)

# Make sure Linux computer. 

	if [[ $OS != "linux" ]] ; then echo "Wrong operating system. This version of Parmanode \
	is for Linux only. Aborting ... " ; enter_continue ; exit 0 ; fi
	# enter_continue is a custom echo function with a read command for confirmation.

# set "trap" conditions; currently makes sure user's terminal reverts to default colours.

	clean_exit 

# Debug - comment out before release.

	# debug_point "Pause here to check for error output before clear screen." 


#Begin program:

	set_terminal # custom function for screen size and colour.
	intro
	sudo_check
	gpg_check
	menu_startup

exit 0
