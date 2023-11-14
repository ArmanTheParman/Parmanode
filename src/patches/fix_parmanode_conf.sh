function fix_parmanode_conf {
delete_line "$dp/parmanode.conf" "nodejs-end" >/dev/null
if grep -q rtl_tor < $dp/parmanode.conf ; then
delete_line "$dp/parmanode.conf" "rtl_tor"
parmanode_conf_add "rtl_tor=true"
fi
}