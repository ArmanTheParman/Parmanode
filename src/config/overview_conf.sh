function overview_conf_add {
if [[ -n $2 ]] ; then
gsed -i "/$2/d" $oc
fi
echo "${1}" | tee -a $oc >/dev/null
}