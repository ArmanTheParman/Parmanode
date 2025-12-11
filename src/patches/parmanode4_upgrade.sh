function parmanode4_upgrade { debugf

grep -q "parmanode4=true" $pc && return 0

make_your_own_parmanode_ca   2>>$errorlog || return 1
make_parmanode_cert          2>>$errorlog || return 1
}