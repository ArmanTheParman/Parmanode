function test_directory_placement {
cd ..
testing_dir=$(pwd)
cd - >/dev/null

if [[ $testing_dir == "$HOME" ]] ; then
test_directory_placement_message
fi

if pwd >/dev/null | grep "$HOME/parmanode" ; then
test_directory_placement_message2
fi

}

function test_directory_placement_message {

clear ; echo "
########################################################################################

    Oh dear, you've downloaded the Parmanode software directly to your home directory.
	This will cause a conflict the the Parmanode installation. Here's what you do:
	after exiting this program, from the command line, type exactly this (case
	sensitive)...

			cd .. && mv parmanode ./Desktop/
	
	Then, you will see the downloaded directory moved to your desktop. You can enter
    the directory from the command line with...

	        cd $HOME/Desktop/parmanode

	Then you can run the program from there with...

			./run_parmanode.sh

	Take a photo of these instructions or copy them to a file if it's hard to remember.

########################################################################################
"
enter_continue && exit 0 	
}

function test_directory_placement_message2 {

clear ; echo "
########################################################################################

    Oh dear, you've downloaded the Parmanode software in a subdirectory of
	$HOME/parmanode 

	This won't do, because Parmanode needs to create a directory of that same name to
	install the program, and doing so will wipe the program you're using now.

    Here's what you do: after exiting this program, move the downloaded parmanode
	directory to somewhere else, eg your Desktop ($HOME/Desktop).
	
    You can enter the directory from the command line with...

	        cd $HOME/Desktop/parmanode

	Then you can run the program from there with...

			./run_parmanode.sh

	Take a photo of these instructions or copy them to a file if it's hard to remember.

########################################################################################
"
enter_continue && exit 0
}