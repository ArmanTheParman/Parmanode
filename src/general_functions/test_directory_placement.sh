function test_directory_placement {



cd ..
testing_dir=$(pwd)
cd -
if [[ $testing_dir == "$HOME" ]] ; then
clear ; echo "
########################################################################################

    Oh dear, you've downloaded the Parmanode software directly to your home directory.
	This will cause a conflict the the Parmanode installation. Here's what you do,
	after exiting this program, from the command line, type exactly this (case
	sensitive)...

			cd .. && mv parmanode ./Desktop/
	
	Then, you will see the downloaded directory moved to your desktop. You can enter
    the directory from the command line with...

	        cd $HOME/Desktop/parmanode

	Then you can run the program from there with...

			./run_parmanode.sh

	Take a photo of these instructions or copy them to a file if it's hard to rmember.

########################################################################################
"
enter_continue && exit 0 
fi

}