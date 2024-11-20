function brew_check {

if which brew >/dev/null 2>&1
    then
	return 0
else

while true ; do
set_terminal
echo -e "
########################################################################################
$cyan
                                    Homebrew
$orange
   Parmanode will install Homebrew on your computer...

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
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; a|p|P) return 1 ;; 
i) break ;;
*) invalid ;;
esac
done

install_homebrew && return 0

set_terminal

# the log function creates a file named argument 1 followed by log. Eg, below,
# the file will be parmanode.log. It will append argument two to the log file 
# and timestamp. Sometimes can be useful if I have problems with debugging, or
# if a user asks for help.
log "parmanode" "Install homebrew failed"
return 1
fi
}
        

