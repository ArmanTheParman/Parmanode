function parmanode4_upgrade {

grep -q "parmanode4=true" $pc && return 0

make_parmanode_ca   2>>$dp/error.log        || return 1
make_parmanode_cert 2>>$dp/error.log       || return 1
sign_parmanode_cert 2>>$dp/error.log       || return 1

parmanode_conf_add "parmanode4=true"
}