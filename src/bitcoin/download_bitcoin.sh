function download_bitcoin { debugf
#not required for installation/setup of system outsite docker.

if [[ $btcpay_combo == "true" ]] || [[ $btcdockerchoice == yes ]] ; then return 0 ; fi
if [[ $bitcoin_compile == "true" ]] ; then return 0 ; fi
# version == self means user has chosen to import own binaries.
if [[ $version == "self" ]] ; then return 0 ; fi
cd $HOME/parmanode/bitcoin
if [[ $btcpayinstallsbitcoin != "true" ]] ; then

if [[ $bitcoin_choice == "knots" ]] ; then printversion=$knotsversion ; else printversion=$version; fi
#currently will never execute, deis is only compiled
if [[ $clientchoice == "deis" ]] ; then printversion="Deis v${deisversion}" ; fi
set_terminal
echo -e "
########################################################################################


    The current version of Bitcoin that will be installed is $printversion 

    Parmanode will verify by hashing the file for you (and gpg verification), but 
    you may wish to learn how to do this yourself.

    My guide on this:
    $cyan
                      https://armantheparman.com/gpg/
$orange
    The downloaded files will be at:
$cyan
                      $HOME/parmanode/bitcoin/
$orange
    To learn more about how to verify yourself:
$cyan
                      https://armantheparman.com/gpg-articles 
$orange

########################################################################################
"
enter_continue
jump $enter_cont
fi

set_terminal ; echo "Downloading Bitcoin files to $HOME/parmanode/bitcoin ..."
download_bitcoin_getfiles || { enter_continue "Something went wrong." ; return 1 ; } #see code for the function below

debug "before verify bitcoin, after download"

if [[ $VERIFY != off ]] ; then
  verify_bitcoin || return 1
fi

unpack_bitcoin >> $pvlog || return 1 # see code for the function below

return 0     
}


function download_bitcoin_getfiles { debugf

#arm64 (m3)
# ARM Pi4 support. If not, checks for 64 bit x86.
while true ; do
debug "versions... knotsbitcoin: $knotsbitcoin, knotsmajor: $knotsmajor, core version: $version"
	     if [[ $chip == "armv7l" || $chip == "armv8l" ]] ; then 		#32 bit Pi4
                [[ $bip110 == "true" ]] && announce "Sorry, BIP110 Knots is not availble for your computer's particular CPU." && return 1

                if [[ $knotsbitcoin == "true" ]] ; then 
                    curl -fsLO https://bitcoinknots.org/files/$knotsmajor/$knotsversion.knots$knotsdate/bitcoin-$knotsversion.knots$knotsdate-arm-linux-gnueabihf.$knotsextension && break 
                    curl -fsLO https://bitcoinknots.org/files/$knotsmajor/$knotsversion.knots$knotsdate/bitcoin-$knotsversion.knots$knotsdate-arm-linux-gnueabihf.$knotsextension && break
                else
		        curl -fsLO https://bitcoincore.org/bin/bitcoin-core-$version/bitcoin-$version-arm-linux-gnueabihf.tar.gz  ; break
                fi
         fi

	     if [[ $chip == "aarch64" && $OS == "Linux" ]] ; then 				

            if [[ $( file /bin/bash | cut -d " " -f 3 ) == "64-bit" ]] ; then

                if [[ $bip110 == "true" ]] ; then
                    curl -fsLO https://github.com/dathonohm/bitcoin/releases/download/v29.2.knots20251110%2Bbip110-v0.1rc1/bitcoin-29.2.knots20251110+bip110-v0.1rc1-aarch64-linux-gnu.tar.gz
                    break
                fi
            
                if [[ $knotsbitcoin == "true" ]] ; then 
                    curl -fsLO https://bitcoinknots.org/files/$knotsmajor/$knotsversion.knots$knotsdate/bitcoin-$knotsversion.knots$knotsdate-aarch64-linux-gnu.$knotsextension && break 
                    curl -fsLO https://bitcoinknots.org/files/$knotsmajor/$knotsversion.knots$knotsdate/bitcoin-$knotsversion.knots$knotsdate-aarch64-linux-gnu.$knotsextension && break 
                else
                    curl -fsLO https://bitcoincore.org/bin/bitcoin-core-$version/bitcoin-$version-aarch64-linux-gnu.tar.gz ; break
                fi
            else #32 bit
                if [[ $knotsbitcoin == "true" ]] ; then 
                    curl -fsLO https://bitcoinknots.org/files/$knotsmajor/$knottsversion.knots$knotsdate/bitcoin-$knotsversion.knots$knotsdate-arm-linux-gnueabihf.$knotsextension && break 
                    curl -fsLO https://bitcoinknots.org/files/$knotsmajor/$knottsversion.knots$knotsdate/bitcoin-$knotsversion.knots$knotsdate-arm-linux-gnueabihf.$knotsextension && break 
                else
                    curl -fsLO https://bitcoincore.org/bin/bitcoin-core-$version/bitcoin-$version-arm-linux-gnueabihf.tar.gz  ; break
                fi
            fi
         fi

 	     if [[ $chip == "x86_64" && $OS == "Linux" ]] ; then debug "x86"

                if [[ $bip110 == "true" ]] ; then
                    curl -fsLO https://github.com/dathonohm/bitcoin/releases/download/v29.2.knots20251110%2Bbip110-v0.1rc1/bitcoin-29.2.knots20251110+bip110-v0.1rc1-x86_64-linux-gnu.tar.gz
                    break
                fi

                if [[ $knotsbitcoin == "true" ]] ; then 
                    curl -fsLO https://bitcoinknots.org/files/$knotsmajor/$knotsversion.knots$knotsdate/bitcoin-$knotsversion.knots$knotsdate-x86_64-linux-gnu.$knotsextension && break 
                    curl -fsLO https://bitcoinknots.org/files/$knotsmajor/$knotsversion.knots$knotsdate/bitcoin-$knotsversion.knots$knotsdate-x86_64-linux-gnu.$knotsextension && break 
                else
                    curl -fsLO https://bitcoincore.org/bin/bitcoin-core-$version/bitcoin-$version-x86_64-linux-gnu.tar.gz  ; break
                fi
         fi

         if [[ ($chip == "arm64" && $OS == "Mac") || ( $chip == "aarch64" && $OS == "Mac") ]] ; then debug "arm64 mac"

            if [[ $bip110 == "true" ]] ; then
                curl -fsLO https://github.com/dathonohm/bitcoin/releases/download/v29.2.knots20251110%2Bbip110-v0.1rc1/bitcoin-29.2.knots20251110+bip110-v0.1rc1-x86_64-apple-darwin.zip
                break
            fi

            if [[ $knotsbitcoin == "true" ]] ; then 
        
            
                curl -fsLO https://bitcoinknots.org/files/$knotsmajor/$knotsversion.knots$knotsdate/bitcoin-$knotsversion.knots$knotsdate-arm64-apple-darwin.$knotsextension && break 
                curl -fsLO https://bitcoinknots.org/files/$knotsmajor/$knotsversion.knots$knotsdate/bitcoin-$knotsversion.knots$knotsdate-arm64-apple-darwin.$knotsextension && break 
            else
                curl -fsLO https://bitcoincore.org/bin/bitcoin-core-$version/bitcoin-$version-arm64-apple-darwin.zip ; break
            fi
         fi

         if [[ $chip == "x86_64" && $OS == "Mac" ]] ; then debug "x86_64 Mac"

                if [[ $bip110 == "true" ]] ; then
                    curl -fsLO https://github.com/dathonohm/bitcoin/releases/download/v29.2.knots20251110%2Bbip110-v0.1rc1/bitcoin-29.2.knots20251110+bip110-v0.1rc1-x86_64-apple-darwin.zip
                    break
                fi         
         
            if [[ $knotsbitcoin == "true" ]] ; then 
                curl -fsLO https://bitcoinknots.org/files/$knotsmajor/$knotsversion.knots$knotsdate/bitcoin-$knotsversion.knots$knotsdate-x86_64-apple-darwin.$knotsextension && break
                curl -fsLO https://bitcoinknots.org/files/$knotsmajor/$knotsversion.knots$knotsdate/bitcoin-$knotsversion.knots$knotsdate-x86_64-apple-darwin.$knotsextension && break 
            else
                curl -fsLO https://bitcoincore.org/bin/bitcoin-core-$version/bitcoin-$version-x86_64-apple-darwin.zip ; break
            fi
         fi
done
return 0
}


function unpack_bitcoin { debugf

if find $hp/bitcoin/ -type f -name "*.zip" 2>$dn | grep -q . >$dn 2>&1 ; then #find returns true when found or not
unzip bitcoin*.zip
fi

debug 

if [[ $OS == "Mac" ]] ; then

    if find $hp/bitcoin/ -type f -name "*.dmg" 2>$dn | grep -q . ; then
        hdiutil attach *.dmg
        $xsudo cp -R /Volumes/Bitcoin*/Bitcoin* /Applications
        hdiutil detach /Volumes/Bitcoin*
    else
        $xsudo cp -R $hp/bitcoin/Bitcoin*app /Applications
    fi
fi

if [[ $OS == "Linux" ]] ; then
set_terminal
mkdir -p $dp/temp/ >$dn 2>&1
tar -xf bitcoin-* -C $dp/temp/ >$dn 2>&1
debug
# Move bitcoin program files to new directory.
# All binaries go to $HOME/parmanode/bitcoin.
mv $dp/temp/bit*/* $hp/bitcoin/

#delete sample bitcoin.conf to avoid confusion.
rm $hp/bitcoin/bitcoin.conf 

# "installs" bitcoin and sets to writing to only root for security. Read/execute for group and others. 
# makes target directories if they don't exist
# "install" is just a glorified copy command
install -m 0755 -o $USER -g $USER -t /usr/local/bin/parmanode $hp/bitcoin/bin/* 2>$pvlog

rm -rf $hp/bitcoin/bin
rm -rf $dp/temp >$dn 2>&1
fi
}