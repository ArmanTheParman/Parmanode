function download_bitcoin {
#not required for installation/setup of system outsite docker.

if [[ $btcpay_combo == "true" ]] || [[ $btcdockerchoice == yes ]] ; then return 0 ; fi
if [[ $bitcoin_compile == "true" ]] ; then return 0 ; fi
# version == self means user has chosen to import own binaries.
if [[ $version == "self" ]] ; then return 0 ; fi
cd $HOME/parmanode/bitcoin
if [[ $btcpayinstallsbitcoin != "true" ]] ; then

if [[ $bitcoin_choice == "knots" ]] ; then printversion=$knotsversion ; else printversion=$version; fi
set_terminal
echo -e "
########################################################################################

   $cyan 
    The current version of Bitcoin that will be installed is$orange $version 
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
download_bitcoin_getfiles || { enter_continue "Something went wrong." ; return 1 ; } #see code for the function below

debug "before verify bitcoin, after download"

if [[ $VERIFY != off ]] ; then
  verify_bitcoin || return 1
fi

unpack_bitcoin || return 1 # see code for the function below

return 0     
}


function download_bitcoin_getfiles {

#arm64 (m3)
# ARM Pi4 support. If not, checks for 64 bit x86.
while true ; do

debug chip is $chip, knots - $knotsbitcoin

	     if [[ $chip == "armv7l" || $chip == "armv8l" ]] ; then 		#32 bit Pi4
                [[ $knotsbitcoin == "true" ]] && curl -LO https://bitcoinknots.org/files/28.x/28.1.knots20250305/bitcoin-28.1.knots20250305-arm-linux-gnueabihf.tar.gz ; break
		        curl -LO https://bitcoincore.org/bin/bitcoin-core-$version/bitcoin-$version-arm-linux-gnueabihf.tar.gz  ; break
         fi

	     if [[ $chip == "aarch64" && $OS == "Linux" ]] ; then 				

            if [[ $( file /bin/bash | cut -d " " -f 3 ) == "64-bit" ]] ; then
                [[ $knotsbitcoin == "true" ]] && curl -LO https://bitcoinknots.org/files/28.x/28.1.knots20250305/bitcoin-28.1.knots20250305-aarch64-linux-gnu.tar.gz ; break
                curl -LO https://bitcoincore.org/bin/bitcoin-core-$version/bitcoin-$version-aarch64-linux-gnu.tar.gz ; break
            else #32 bit
                [[ $knotsbitcoin == "true" ]] && curl -LO https://bitcoinknots.org/files/28.x/28.1.knots20250305/bitcoin-28.1.knots20250305-arm-linux-gnueabihf.tar.gz ; break
                curl -LO https://bitcoincore.org/bin/bitcoin-core-$version/bitcoin-$version-arm-linux-gnueabihf.tar.gz  ; break
            fi
         fi

 	     if [[ $chip == "x86_64" && $OS == "Linux" ]] ; then 
                debug "x86"
                [[ $knotsbitcoin == "true" ]] && curl -LO https://bitcoinknots.org/files/28.x/28.1.knots20250305/bitcoin-28.1.knots20250305-x86_64-linux-gnu.tar.gz ; break
                debug "x86"
		        curl -LO https://bitcoincore.org/bin/bitcoin-core-$version/bitcoin-$version-x86_64-linux-gnu.tar.gz  ; break
                debug "x86"
         fi

         if [[ ($chip == "arm64" && $OS == Mac) || ( $chip == "aarch64" && $OS == Mac) ]] ; then

            [[ $knotsbitcoin == "true" ]] && curl -LO https://bitcoinknots.org/files/27.x/27.1.knots20240801/bitcoin-27.1.knots20240801-arm64-apple-darwin.dmg ; break  
            curl -LO https://bitcoincore.org/bin/bitcoin-core-$version/bitcoin-$version-arm64-apple-darwin.zip ; unzip bitcoin*.zip ; zip="true" ; break
         fi

         if [[ $chip == "x86_64" && $OS == Mac ]] ; then
            [[ $knotsbitcoin == "true" ]] && curl -LO https://bitcoinknots.org/files/27.x/27.1.knots20240801/bitcoin-27.1.knots20240801-x86_64-apple-darwin.dmg ; break
            curl -LO https://bitcoincore.org/bin/bitcoin-core-$version/bitcoin-$version-x86_64-apple-darwin.zip ; unzip bitcoin*.zip ; zip="true" ; break
         fi
done
debug after break
return 0
}


function unpack_bitcoin {

if [[ $OS == "Mac" && $zip != "true" ]] ; then
hdiutil attach *.dmg
sudo cp -r /Volumes/Bitcoin*/Bitcoin* /Applications
hdiutil detach /Volumes/Bitcoin*
elif [[ $zip == "true" ]] ; then
sudo cp -r ./Bitcoin* /Applications
fi

if [[ $OS == "Linux" ]] ; then
set_terminal
mkdir -p $dp/temp/ >$dn 2>&1
tar -xf bitcoin-* -C $dp/temp/ >$dn 2>&1

# Move bitcoin program files to new directory.
# All binaries go to $HOME/parmanode/bitcoin.
mv $dp/temp/bit*/* $hp/bitcoin/

#delete sample bitcoin.conf to avoid confusion.
rm $hp/bitcoin/bitcoin.conf 

# "installs" bitcoin and sets to writing to only root for security. Read/execute for group and others. 
# makes target directories if they don't exist
# "install" is just a glorified copy command
sudo install -m 0755 -o $(whoami) -g $(whoami) -t /usr/local/bin $hp/bitcoin/bin/*

sudo rm -rf $hp/bitcoin/bin
sudo rm -rf $dp/temp >$dn 2>&1
fi
}