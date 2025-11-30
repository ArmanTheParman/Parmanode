function makedir {
echo "$1" >> $tmp/makedir.log
test -d "$1" && return 0

mkdir -p "$1"

ls -lah "$1" >$dn 2>&1 || return 1

}
