function parmabox_build  {
cd $HOME/parman_programs/parmanode/src/parmabox
docker build --no-cache -t parmabox .
}