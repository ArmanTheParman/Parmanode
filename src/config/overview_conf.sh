function overview_conf_add {
delete_line "$oc" "${1}"
debug "overview conf add"
echo "${1}" | tee -a $oc >/dev/null
debug "look, ${1}, oc is $oc"
}