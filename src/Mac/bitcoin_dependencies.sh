function bitcoin_dependencies {
while true ; do
if command -v brew >/dev/null 2>&1
	then
	true
	else
    break
	fi

while true ; do
set_terminal
echo "
########################################################################################

                      Installing dependencies for Bitcoin Core

    Parmanode needs to install Bitcoin dependencies. You can skip this but you may 
    get errors. It may take 5 to 10 minutes. If this waiting is getting to you, let
    that be a lesson to you that you should have learned to use Linux. :( 

    Linux users running Parmanode would already have begun syncing the blockchain by
    now, just saying. A great book to get started is \"The Command Line Book\" by
    William Shotts, 5th internet eddition, free PDF.


				<enter>    Install dependencies
				
				s)         Skip

########################################################################################
"
choose "x" ; read choice

if [[ $choice == "s" ]] ; then break 2 ; fi
if [[ $choice == "" ]] ; then break ; fi
invalid
done

# while loop breaks to here
please_wait
brew install automake libtool boost pkg-config libevent zeromq berkeley-db@4 && \
return 0 
set_terminal
echo "Error installing Bitcoin dependencies. You should try again. Proceed with caution."
read
done

########################################################################################

#for silicon chip macs, needs to add brew to path

if [[ $(uname -m) == "arm64" ]] ; then
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)" >/dev/null
fi

}


