function make_dot_parmanode {
if [[ ! -d $HOME/.parmanode ]] ; then
#Should only ever run once
mkdir $HOME/.parmanode >$dn 2>&1
debug "dp made"
touch $HOME/.parmanode/.new_install
fi
}
