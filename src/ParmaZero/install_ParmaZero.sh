function install_ParmaZero {

ParmaZero_intro || return 1

cd ; rm -rf $HOME/parman_programs/ParmaZero
mkdir -p $HOME/parman_programs/ParmaZero/
export PZdir="$HOME/parman_programs/ParmaZero"
cd $PZdir

# Download zip file and sig and hashfile
curl -LO https://downloads.raspberrypi.org/raspios_oldstable_armhf/images/raspios_oldstable_armhf-2022-09-26/2022-09-22-raspios-buster-armhf.img.xz
curl -LO https://downloads.raspberrypi.org/raspios_oldstable_armhf/images/raspios_oldstable_armhf-2022-09-26/2022-09-22-raspios-buster-armhf.img.xz.sha256
curl -LO https://downloads.raspberrypi.org/raspios_oldstable_armhf/images/raspios_oldstable_armhf-2022-09-26/2022-09-22-raspios-buster-armhf.img.xz.sig

gpg --import $HOME/parman_programs/parmanode/ParmaZero/Raspberry_Pi.pubkey
gpg --verify *sig *sha256

hash_value=$(cat *sha256 | cut -d ' ' -f 1)

if ! shasum -a 256 --ignore-missing --check *sha256 ; then log "parmazero" "checksum failed" ; echo "failed" ; enter_continue ; return 1 ; fi

if ! gpg --verify *.sig 2>&1 | grep "Good" ; then # it is vital for the "2>&1" to remain for this function to work
announce "gpg failesd. aborting." ; return 1 
fi 

ParmaZero_unzip

detect_microSD ParmaZero || return 1 #gets $disk variable

unmount_microSD

ParmaZero_write

Success "ParmaZero" "being flashed to the microSD card."
}