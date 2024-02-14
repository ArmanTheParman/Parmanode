function install_gsed {

if which gsed >/dev/null ; then return 0 ; fi

if [[ $(uname) != Darwin ]] ; then return 1 ; fi

if ! which brew >/dev/null ; then install brew || return 1 ; fi

brew install gsed || return 1 

}