function get_PiOS {

cd $HOME/ParmanodL

# Get Rasbperry Pi OS, 64 bit, with Desktop.

	if [ ! -e $zip_path ] ; then
	please_wait
	curl -LO https://downloads.raspberrypi.org/raspios_arm64/images/raspios_arm64-2023-05-03/$zip_file || \
	{ announce "Failed do download Pi OS image. Aborting." ; return 1 ; }
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

	if [ ! -e "$image_path" ] ; then
        	if ! which xz >/dev/null ; then announce "No xz program detected to unzip. Aborting." ; return 1 ; fi 
        	xz -vkd $zip_path || { announce "Failed to unzip image file" ; return 1 ; }
	else
 	        if ! shasum -a 256 $image_path | grep -q $hash_image ; then
	            rm "$image_path"
  	            get_PiOS || return 1 #function calls itself, but this time faulty img file deleted.
                fi
	fi
}
