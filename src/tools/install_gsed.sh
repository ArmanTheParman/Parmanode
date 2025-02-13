function install_gsed {

if which gsed >$dn ; then return 0 ; fi
nogsedtest
if [[ $(uname) != Darwin ]] ; then return 1 ; fi

if ! which brew >$dn ; then install brew || return 1 ; fi

brew install gsed || return 1 

}