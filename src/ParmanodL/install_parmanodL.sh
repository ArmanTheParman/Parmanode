function install_ParmanodL {

mkdir -p $HOME/parman_programs/ParmanodL 
cd $HOME/parman_programs/ParmanodL
curl -LO https://downloads.raspberrypi.org/raspios_arm64/images/raspios_arm64-2023-05-03/2023-05-03-raspios-bullseye-arm64.img.xz

shasum -a 256 *.img.xz | grep 





}