function makedir {
echo $(whoami) >> /tmp/whoamitest
test -d "$1" && return 0

mkdir -p "$1"

ls -lah "$1" >$dn 2>&1 || errorlog "${FUNCNAME[0]}"

}