function download_bitcoin {
# version == self means user has chosen to import own binaries.
if [[ $version == self ]] ; then return 0 ; fi
debug "in download bitcoin, version = $version"

cd $HOME/parmanode/bitcoin
set_terminal
echo -e "
########################################################################################

   $cyan 
    The current version of Bitcoin Core that will be installed is $version
$orange

    Parmanode will verify by hashing the file for you (and gpg verification), but 
    you may wish to learn how to do this yourself.

    The downloaded files will be at:
$pink    
                      /home/$(whoami)/parmanode/bitcoin/
$orange
    To learn more about how to verify yourself:
$pink
                      https://armantheparman.com/gpg-articles 
$orange

########################################################################################
"
enter_continue

set_terminal ; echo "Downloading Bitcoin files to $HOME/parmanode/bitcoin ..."



# ARM Pi4 support. If not, checks for 64 bit x86.

	     if [[ $chip == "armv7l" || $chip == "armv8l" ]] ; then 		#32 bit Pi4

		        curl -LO https://bitcoincore.org/bin/bitcoin-core-$version/bitcoin-$version-arm-linux-gnueabihf.tar.gz ; fi

	     if [[ $chip == "aarch64" && $OS == Linux ]] ; then 				

            if [[ $( file /bin/bash | cut -d " " -f 3 ) == "64-bit" ]] ; then
                curl -LO https://bitcoincore.org/bin/bitcoin-core-$version/bitcoin-$version-aarch64-linux-gnu.tar.gz 
            else
                curl -LO https://bitcoincore.org/bin/bitcoin-core-$version/bitcoin-$version-arm-linux-gnueabihf.tar.gz ; fi
            fi

 	     if [[ $chip == "x86_64" && $OS == Linux ]] ; then 
		        curl -LO https://bitcoincore.org/bin/bitcoin-core-$version/bitcoin-$version-x86_64-linux-gnu.tar.gz ; fi

         if [[ ($chip == "arm64" && $OS == Mac) || ( $chip == "aarch64" && $OS == Mac) ]] ; then
         curl -LO https://bitcoincore.org/bin/bitcoin-core-$version/bitcoin-$version-arm64-apple-darwin.dmg
         fi

        if [[ $chip == "x86_64" && $OS == Mac ]] ; then
        curl -LO https://bitcoincore.org/bin/bitcoin-core-$version/bitcoin-$version-x86_64-apple-darwin.dmg
        fi

if [[ $VERIFY != off ]] ; then
  verify_bitcoin || return 1
fi

#unpack Bitcoin core:
if [[ $OS == Mac ]] ; then
hdiutil attach bitcoin*.dmg
sudo cp -r /Volumes/Bitcoin*/Bitcoin* /Applications
hdiutil detach /Volumes/Bitcoin*
fi

if [[ $OS == Linux ]] ; then
set_terminal
mkdir $HOME/.parmanode/temp/ >/dev/null 2>&1
tar -xf bitcoin-* -C $HOME/.parmanode/temp/ >/dev/null 2>&1

# Move bitcoin program files to new directory.
# All binaries go to $HOME/parmanode/bitcoin.
mv $HOME/.parmanode/temp/b*/* $HOME/parmanode/bitcoin/

#delete sample bitcoin.conf to avoid confusion.
rm $HOME/parmanode/bitcoin/bitcoin.conf 

# "installs" bitcoin and sets to writing to only root for security. Read/execute for group and others. 
# makes target directories if they don't exist
# "install" is just a glorified copy command
sudo install -m 0755 -o $(whoami) -g $(whoami) -t /usr/local/bin $HOME/parmanode/bitcoin/bin/*

sudo rm -rf $HOME/parmanode/bitcoin/bin
fi

return 0     
}
