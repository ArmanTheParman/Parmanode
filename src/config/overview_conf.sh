function overview_conf_add {
if [[ -n $2 ]] ; then
gsed -i "/$2/d" $oc >/dev/null 2>&1
fi
echo "${1}" | tee -a $oc >/dev/null 2>&1
}