function fix_nodejs_conf {
delete_line "$dp/parmanode.conf" "nodejs-end" >/dev/null
}