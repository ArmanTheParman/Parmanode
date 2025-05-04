function parmaview_build  {
cd $HOME/parman_programs/parmanode/src/ParmaView
docker build -t parmaview . || return 1
return 0
}