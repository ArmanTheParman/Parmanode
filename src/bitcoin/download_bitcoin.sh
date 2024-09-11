function download_bitcoin {

#not required for installation/setup of system outsite docker.

if [[ $btcpay_combo == "true" ]] || [[ $btcdockerchoice == yes ]] ; then return 0 ; fi

# version == self means user has chosen to import own binaries.
if [[ $version == self ]] ; then return 0 ; fi

cd $HOME/parmanode/bitcoin
if [[ $btcpayinstallsbitcoin != "true" ]] ; then
set_terminal
echo -e "
########################################################################################

   $cyan 
    The current version of Bitcoin Core that will be installed is$orange $version $knotsversion
$orange
    Parmanode will verify by hashing the file for you (and gpg verification), but 
    you may wish to learn how to do this yourself.

    The downloaded files will be at:
$pink    
                      $HOME/parmanode/bitcoin/
$orange
    To learn more about how to verify yourself:
$pink
                      https://armantheparman.com/gpg-articles 
$orange

########################################################################################
"
enter_continue
fi

set_terminal ; echo "Downloading Bitcoin files to $HOME/parmanode/bitcoin ..."


# ARM Pi4 support. If not, checks for 64 bit x86.
while true ; do

	     if [[ $chip == "armv7l" || $chip == "armv8l" ]] ; then 		#32 bit Pi4
		        curl -LO https://bitcoincore.org/bin/bitcoin-core-$version/bitcoin-$version-arm-linux-gnueabihf.tar.gz  ; break
         fi

	     if [[ $chip == "aarch64" && $OS == Linux ]] ; then 				

            if [[ $( file /bin/bash | cut -d " " -f 3 ) == "64-bit" ]] ; then
                curl -LO https://bitcoincore.org/bin/bitcoin-core-$version/bitcoin-$version-aarch64-linux-gnu.tar.gz ; break
            else
                curl -LO https://bitcoincore.org/bin/bitcoin-core-$version/bitcoin-$version-arm-linux-gnueabihf.tar.gz  ; break
            fi
         fi

 	     if [[ $chip == "x86_64" && $OS == Linux ]] ; then 
		        curl -LO https://bitcoincore.org/bin/bitcoin-core-$version/bitcoin-$version-x86_64-linux-gnu.tar.gz  ; break
         fi

         if [[ ($chip == "arm64" && $OS == Mac) || ( $chip == "aarch64" && $OS == Mac) ]] ; then

            if [[ $knotsbitcoin == "true" ]] ; then
                curl -LO https://bitcoinknots.org/files/27.x/27.1.knots20240801/bitcoin-27.1.knots20240801-x86_64-apple-darwin.dmg ; break  
            fi

            curl -LO https://bitcoincore.org/bin/bitcoin-core-$version/bitcoin-$version-arm64-apple-darwin.dmg ; break
         fi

         if [[ $chip == "x86_64" && $OS == Mac ]] ; then
            if [[ $knotsbitcoin == "true" ]] ; then
                curl -LO https://bitcoinknots.org/files/27.x/27.1.knots20240801/bitcoin-27.1.knots20240801-x86_64-apple-darwin.dmg ; break
            fi    
            curl -LO https://bitcoincore.org/bin/bitcoin-core-$version/bitcoin-$version-x86_64-apple-darwin.dmg ; break
         fi
done

debug "before verify bitcoin, after download"

if [[ $VERIFY != off ]] ; then
  verify_bitcoin || return 1
fi

#unpack Bitcoin core:
if [[ $OS == Mac ]] ; then
hdiutil attach *.dmg
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
