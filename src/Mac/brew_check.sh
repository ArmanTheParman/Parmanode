function brew_check {

if command -v brew >/dev/null 2>&1
    then
	return 0
    else
while true ; do
set_terminal
echo "
########################################################################################

                                     Homebrew

   In order to install certain dependencies (dependencies are fragments of code that 
   Bitcoin needs to function) Homebrew is needed. Homebrew is a package manager (a 
   program that manages certain other programs' installation and maintenance on your 
   system via web servers where the software is delievered to you). 

   Parmanode has detected that Homebrew has not been installed on your system before.
   It will do this for you now, with your approval. It doesn't harm or slow down
   your system, but it is a real pain to download - it's going to take a while. Make
   sure your computer doesn't go into hybernation during the process to save power. It
   may take around 30 minutes, speaking from experience (I tested with an old Mac).
   
                            i)    Install Homebrew 
				
                            s)    Skip

########################################################################################
"
choose "epq" ; read choice
# below is my menu logic before I got comfortable using case.
# I'm leaving it here for interest, it works fine and doesn't hurt.
if [[ $choice == "p" ]] ; then return 1 ; fi
if [[ $choice == "q" ]] ; then exit 0 ; fi
if [[ $choice == "s" ]] ; then return 0 ; fi
if [[ $choice == "i" ]] ; then break ; fi
invalid
done
log "parmanode" "Installing homebrew..."
# User chose <enter>, while breaks to here:

install_homebrew && return 0

set_terminal

announce "Download homebrew failed. Unknown error. You should try again." "\
Proceed with caution."
# announce takes 1 or 2 arguments and prints on a seperate line each with 
# a nice border above and below. The \ at the end of the line continues the code
# ont he second line as if there is no new line.
# announce also includes an enter_continue command.

# the log function creates a file named argument 1 followed by log. Eg, below,
# the file will be parmanode.log. It will append argument two to the log file 
# and timestamp. Sometimes can be useful if I have problems with debugging, or
# if a user asks for help.
log "parmanode" "Install homebrew failed"
return 0
fi
}
        

