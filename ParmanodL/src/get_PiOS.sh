function get_PiOS {

# Get Rasbperry Pi OS, 64 bit, with Desktop.

	cd $HOME/ParmanodL || { echo "failed to cd in get_PiOS" && sleep 3 ; exit ; }

	if [ ! -e $zip ] ; then
	please_wait
	curl -LO https://downloads.raspberrypi.org/raspios_arm64/images/raspios_arm64-2023-05-03/$zip || \
	{ announce "Failed do download Pi OS image. Aborting." ; return 1 ; }
	fi

# Check integrity.

	if ! shasum -a 256 "$HOME/ParmanodL/$zip" | grep -q $hash ; then
		announce "sha256 failed. Aborting" ; return 1
    else
	    echo "Sha256 success. Continuing" ; sleep 2  	
	fi

# Unzip file.

	if [ ! -e $HOME/ParmanodL/$image ] ; then
	xz -vkd $zip || { announce "Failed to unzip image file" ; return 1 ; }
	fi
}