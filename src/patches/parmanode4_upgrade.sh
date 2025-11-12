function parmanode4_upgrade {
make_parmanode_ca         || return 1
make_parmanode_cert       || return 1
sign_parmanode_cert       || return 1


parmanode_conf_add "parmanode4=true"
}