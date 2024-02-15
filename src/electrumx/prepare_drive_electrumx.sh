function prepare_drive_electrumx {

mkdir -p $HOME/.electrumx

if [[ $drive_electrumx == "internal" ]] ; then
        mkdir -p $HOME/parmanode/electrumx/electrumx_db && return 0
        #move backed up db directory here later if selected
fi

if [[ $drive_electrumx == "external" ]] ; then
 return 0
fi  
}