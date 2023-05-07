function bitcoin_dependencies {

if command -v brew >/dev/null 2>&1
	then
	true
	else
    exit 0
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
choose "epq" ; read choice

if [[ $choice == "p" ]] ; then return 1 ; fi
if [[ $choice == "q" ]] ; then exit 0 ; fi
if [[ $choice == "s" ]] ; then return 0 ; fi
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
return 0
}


