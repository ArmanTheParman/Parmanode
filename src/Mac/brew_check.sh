function brew_check {

if command -v brew >/dev/null 2>&1
    then
	return 0
    else
while true ; do
set_terminal
software="the software"
if [[ -n $1 ]] ; then software="$1" ; fi
echo -e "
########################################################################################
$cyan
                                     Homebrew
$orange
   In order for $software to work properly, Parmanode needs to install Homebrew 
   on your computer.

   Homebrew is a package manager (a program that manages certain other programs' 
   installation and maintenance on your system via web servers where the software is 
   delievered to you). 

   Homebrew will be installed now with your approval. It doesn't harm or slow down
   your system, but it is a real pain to download - it's going to take a while. Maybe
   even 30 minutes to an hour or so. Make sure your computer doesn't go into 
   hybernation during the process to save power. 
   
                            i)    Install Homebrew 
				
                            a)    Abort

########################################################################################
"
choose "epq" ; read choice
# below is my menu logic before I got comfortable using case.
# I'm leaving it here for interest, it works fine and doesn't hurt.
if [[ $choice == "p" ]] ; then return 1 ; fi
if [[ $choice == "q" ]] ; then exit 0 ; fi
if [[ $choice == "a" ]] ; then return 1 ; fi
if [[ $choice == "i" ]] ; then break ; fi
done
log "parmanode" "Installing homebrew..."
# User chose <enter>, while breaks to here:

install_homebrew && return 0

set_terminal

# announce takes 1 or 2 arguments and prints on a seperate line each with 
# a nice border above and below. The \ at the end of the line continues the code
# ont he second line as if there is no new line.
# announce also includes an enter_continue command.

# the log function creates a file named argument 1 followed by log. Eg, below,
# the file will be parmanode.log. It will append argument two to the log file 
# and timestamp. Sometimes can be useful if I have problems with debugging, or
# if a user asks for help.
log "parmanode" "Install homebrew failed"
return 1
fi
}
        

