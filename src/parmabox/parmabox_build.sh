function parmabox_build  {
cd $HOME/parman_programs/parmanode/src/parmabox
docker build -t parmabox . || return 1
return 0
}