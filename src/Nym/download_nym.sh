function download_nym { debugf

cd $HOME/parmanode/nym

get_nym_files || { sww ; return 1 ; }

if [[ "$VERIFY" != "off" ]] ; then
  verify_nym || return 1
fi

return 0     
}


function get_nym_files { debugf

while true ; do

	     if [[ $chip == "armv7l" || $chip == "armv8l" ]] ; then 		#32 bit Pi4
            sww "Nym is not available for your computer type" 
            return 1
         fi

	     if [[ $chip == "aarch64" && $OS == "Linux" ]] ; then #64 bit Pi
            if [[ $( file /bin/bash | cut -d " " -f 3 ) == "64-bit" ]] ; then
                curl -LO https://github.com/nymtech/nym-vpn-client/releases/download/nym-vpn-app-v1.28.0/NymVPN_1.28.0_aarch64.AppImage
                break
            else #32 bit
                sww "Nym is not available for your computer type" 
                return 1
            fi
        fi

 	     if [[ $chip == "x86_64" && $OS == "Linux" ]] ; then debug "x86"
             curl -LO https://github.com/nymtech/nym-vpn-client/releases/download/nym-vpn-app-v1.28.0/NymVPN_1.28.0_amd64.AppImage
             break
         fi

         if [[ ($chip == "arm64" && $OS == "Mac") || ( $chip == "aarch64" && $OS == "Mac") ]] ; then debug "arm64 mac"
             no_mac
             return 1
         fi

         if [[ $chip == "x86_64" && $OS == "Mac" ]] ; then debug "x86_64 Mac"
             no_mac
             return 1
        fik

done
return 0
}
