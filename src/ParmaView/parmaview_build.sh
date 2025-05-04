function parmaview_build  {
cd $HOME/parman_programs/parmanode/src/parmaview
docker build -t parmaview . || return 1
return 0
}