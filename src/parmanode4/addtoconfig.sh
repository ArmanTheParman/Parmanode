#comma separated list of arguments, key1=val1,key2=val2 etc...
#nesting with !, eg bitcoin!drive=/dev/sda

function addtoconfig {

#exit if malformed function call
grep -q "=" <<<"$*" | return 1 
[[ -z $1 ]] || return 1

IFS=, read -r -a items <<<"$*"

tmp1=$(mktemp)
for item in "${items[@]}" ; do

    key=${item%=*}
    val=${item#*=}

    if  [[ $(countchar "$key" "!") == 1 ]] ; then
        key1=${key%!*}
        key2=${key#*!}
        jq --arg key1 "$key1" --arg key2 "$key2" --arg val "$val" '.[$key1][$key2] = $val' $p4 > $tmp1 && cp $tmp1 $p4
    elif  [[ $(countchar "$key" "!") == 2 ]] ; then
        key1=${key%%!*}
        key3=${key##*!}
        int1=${key%!*}
        key2=${int1#*!}
        jq --arg key1 "$key1" --arg key2 "$key2" --arg key3 "$key3" --arg val "$val" '.[$key1][$key2][$key3] = $val' $p4 > $tmp1 && cp $tmp1 $p4
    else 
        jq --arg key "$key" --arg val "$val" '.[$key] = $val' $p4 > $tmp1 && cp $tmp1 $p4
    fi

done
rm $tmp1
}


