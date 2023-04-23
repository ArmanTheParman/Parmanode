function brew_check {

if command -v brew >/dev/null 2>&1
    then
    log "parmanode" "Brew already installed."
	return 0
    else
    log "parmanode" "Brew not yet installed."
while true ; do
set_terminal
echo "
########################################################################################

                                     Homebrew

   In order to install certain dependencies (these are fragments of code that Bitcoin
   needs to function) Homebrew is needed. Homebrew is a package manager (a program
   that manages certain other programs' installation and maintenance on your system
   via web servers where the software is delievered to you). 

   Parmanode has detected that Homebrew has not been installed on your system before.
   It will do this for you now, with your approval. It doesn't harm or slow down
   your system, but it is a real pain to download - it's going to take a while. Make
   sure your computer doesn't go into hybernation during the process to save power. It
   may take around 30 minutes, speaking from experience (I have an old Mac).
   
                            i)    Install Homebrew 
				
                            s)    Skip

########################################################################################
"
choose "epq" ; read choice
if [[ $choice == "p" ]] ; then return 1 ; fi
if [[ $choice == "q" ]] ; then exit 0 ; fi
if [[ $choice == "s" ]] ; then return 0 ; fi
if [[ $choice == "i" ]] ; then break ; fi
invalid
done
log "parmanode" "Installing homebrew..."
# User chose <enter>, while breaks to here:
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && return 0

set_terminal
echo "Download homebrew failed. Unknown error. You should try again. 
Proceed with caution."
log "parmanode" "Install homebrew failed"
return 0
fi
}
        

