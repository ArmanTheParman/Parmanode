function make_dot_parmanode {
if [[ ! -d $HOME/.parmanode ]] ; then
#Should only ever run once
mkdir $HOME/.parmanode >/dev/null 2>&1
touch $HOME/.parmanode/.new_install
fi
}
