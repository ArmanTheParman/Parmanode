function makedir {
#exit success if directory exits
    test -d "$1" && return 0
#exit error if not a absolute patch, otherwise directory can be made in a weird place
    [[ ${1:0:1} == '/' ]] || return 1
#make dir
    mkdir -p "$1"
#text is exits and is accessible to the current cgi user
    ls -lah "$1" >$dn 2>&1 || return 1
}
