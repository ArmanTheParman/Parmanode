function parmabox_build  {
cd $HOME/parman_programs/parmanode/src/parmabox

if [[ $fast == debug ]] ; then
docker build -t parmabox .
return 0
fi

docker build --no-cache -t parmabox .
}