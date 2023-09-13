function prepare_drive_electrs {

mkdir -p $HOME/.electrs

if [[ $drive_electrs == "internal" ]] ; then
    mkdir -p $HOME/parmanode/electrs/electrs_db && return 0
fi

if [[ $drive_electrs == "external" ]] ; then
    mkdir -p /media/$USER/parmanode/electrs_db && return 0
fi  

return 1
}