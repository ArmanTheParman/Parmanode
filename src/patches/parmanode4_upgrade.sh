function parmanode4_upgrade {

! grep -q "parmanode4=true" $pc && return 0

make_parmanode_ca         || return 1
make_parmanode_cert       || return 1
sign_parmanode_cert       || return 1


parmanode_conf_add "parmanode4=true"
}