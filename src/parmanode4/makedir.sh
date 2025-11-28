function makedir {
echo $(whoami) >> /tmp/whoamitest
echo "ARG=[$1]" >> /tmp/makedir_debug.txt
test -d "$1" && return 0

mkdir -p "$1"

ls -lah "$1" >$dn 2>&1 || errorlog "${FUNCNAME[0]}"

}