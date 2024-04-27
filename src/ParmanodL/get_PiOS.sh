function get_PiOS {
if [[ $arg2 = fast ]] ; then
return 0 
fi

cd $HOME/ParmanodL

if shasum -a 256 $image_file | grep -q $hash_image ; then return 0 ; fi

# Get Rasbperry Pi OS, 64 bit, with Desktop.

	if [ ! -e $zip_path ] ; then
	please_wait
	curl -LO https://downloads.raspberrypi.org/raspios_arm64/images/raspios_arm64-2024-03-15/$zip_file || \
	{ announce "Failed to download Pi OS image. Aborting." ; return 1 ; }
	fi

# Check integrity.

	if ! shasum -a 256 "$zip_path" | grep -q $hash_zip ; then
		announce "sha256 failed. Aborting" ; return 1
    else
	    echo "Sha256 of PiOS success. Continuing" 
		sleep 2
		clear
		please_wait
	fi

# Unzip file.

	if [ ! -e "$image_path" ] ; then #img file doesn't exist, so need to unzip it
        	if ! which xz >/dev/null ; then announce "No xz program detected to unzip. Aborting." ; return 1 ; fi 
        	xz -vkd $zip_path || { announce "Failed to unzip image file" ; return 1 ; }
			debug "finished unzip with xz"
	else
 	        if ! shasum -a 256 $image_path | grep -q $hash_image ; then
	            rm "$image_path"
  	            get_PiOS || return 1 #function calls itself, but this time faulty img file deleted.
		    fi
	fi
}