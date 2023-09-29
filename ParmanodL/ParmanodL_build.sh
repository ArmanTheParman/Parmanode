# Building a ParmanodL for a Pi4 using a Pi4

function ParmanodL_build {

# Debug toggle
if [[ $1 == d ]] ; then export debug=true ; else export debug=false ; fi
# set terminal
printf '\033[8;38;88t' && echo -e "\033[38;2;255;145;0m" 
# source modules
for file in ~/parman_programs/parmanode/ParmanodL/src/**/*.sh ; do source $file ; done

ParmanodL_intro
Pi64_only || exit
parmanode_update2 || get_parmanode || exit # also ensures git will be installed
source_parmanode
ParmanodL_directories

get_PiOS
ParmanodL_mount
ParmanodL_chroot ; debug "pause here and check stuff"
ParmanodL_unmount
Parmanodl_write 
set_terminal ; echo "
########################################################################################

                                S U C C E S S !!

    The microSD card should be ready to eject and put into your Pi4. Attach the Pi 4
	to an internet connection with an ethernet cable, and then power it on.

	The Parmanode software is installed on it. When you want to use it to run Bitcoin,
	you'll need an external SSD hard drive - 1 terabyte is recommended.

	Attach a monitor and keyboard to the Pi for a desktop environment.

	Or, you can SSH into the Pi with:
	
	        ssh parman@parmanodl.local
	
	You might get a "known hosts" error. Simply delete the file:

	        $HOME/.ssh/known_hosts

	then try again.

	The password for the ParmanodL is "parmanodl". You'll need to change it when you
	first log in with SSH.

	Enjoy.						
########################################################################################
"
enter_continue
}

function part2 {

# put microSD in pi
# wait
# ssh parmanodl.local 
# need set password, then will get logged out.
true
}


#RUN PROGRAM
#ParmanodL_build

#remember to set terminal wider for ssh into parmanodL
