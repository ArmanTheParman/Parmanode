function countchar {
[[ -z $1 || ${#2} -ne 1 ]] && return 1
echo "$1" | tr -cd "$2" | wc -c
}