function p4progress {

[[ $parmaview == 1 ]] || return 1

echo "$*" >> $pvlog 2>&1

}