function get_PiOS {

#Rasbperry Pi OS, 64 bit, with Desktop.
	cd $HOME/parman_programs/ParmanodL
	if [ ! -e 2023-05-03-raspios-bullseye-arm64.img.xz ] ; then
	curl -LO https://downloads.raspberrypi.org/raspios_arm64/images/raspios_arm64-2023-05-03/2023-05-03-raspios-bullseye-arm64.img.xz

	# Check integrity.

		if ! shasum -a 256 *.img.xz | grep e7c0c89db32d457298fbe93195e9d11e3e6b4eb9e0683a7beb1598ea39a0a7aa ; then
			echo "sha256 failed. Aborting"
			enter_continue
			return 1
		fi
	fi

	if [ ! -e 2023-05-03-raspios-bullseye-arm64.img ] ; then
	# Unzip the image:
	xz -vkd 2023-05-03-raspios-bullseye-arm64.img.xz
	sleep 3
    debug "pause and check img"	
	fi
}