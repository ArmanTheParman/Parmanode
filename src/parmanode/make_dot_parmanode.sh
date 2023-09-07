function make_dot_parmanode {

#make parmanode hidden directory

mkdir $HOME/.parmanode >/dev/null 2>&1

# the first real change to the computer, so the installation has "begun".
# interruption before "parmanode-end" is added, indicates in incomplete install
# which would need cleaning up.
installed_config_add "parmanode-start" >/dev/null 2>&1 

}