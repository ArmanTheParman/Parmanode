function overview_conf_add {
if [[ -n $2 ]] ; then
delete_line "$oc" "$2"
fi
echo "${1}" | tee -a $oc >/dev/null
}