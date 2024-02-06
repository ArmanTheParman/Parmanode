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

	if [ ! -e "$image_path" ] ; then #img file doesn't exist, so need to unzip it
	        echo "$image_path doesn't exist"
        	if ! which xz >/dev/null ; then announce "No xz program detected to unzip. Aborting." ; return 1 ; fi 
        	xz -vkd $zip_path || { announce "Failed to unzip image file" ; return 1 ; }
			echo "unzipped"
	else
	        echo "$image_path does exist" #img file exists, so hash it and check it.
 	        if ! shasum -a 256 $image_path | grep -q $hash_image ; then
			    echo "hash is wrong, deleting image"
	            rm "$image_path"
  	            get_PiOS || return 1 #function calls itself, but this time faulty img file deleted.
            else
			    echo "hash is right"   
		    fi
	fi
echo "pausing. hit <enter> to continue." ; read
}

		# export zip_file="2023-05-03-raspios-bullseye-arm64.img.xz"
		# export zip_path="$HOME/ParmanodL/$zip_file"
		# export image_file="2023-05-03-raspios-bullseye-arm64.img"
		# export image_path="$HOME/ParmanodL/$image_file" 
		# export hash_zip="e7c0c89db32d457298fbe93195e9d11e3e6b4eb9e0683a7beb1598ea39a0a7aa"
		# export hash_image="962780be6bb41522532f26449f67524dc61038673833c079808da9ca2ad9a4f0"
		# export mnt="$HOME/mnt"
 