#commad separated list of arguments, key1=val1,key2=val2 etc...

function addToConfig {

IFS=, read -r -a items <<<"$*"
tmp1=$(mktemp)
for item in "${items[@]}" ; do

    key=${item%=*}
    val=${item#*=}

    if  [[ $(countchar "$key" "_") == 1 ]] ; then
        key1=${key%_*}
        key2=${key#*_}
        jq --arg key1 "$key1" --arg key2 "$key2" --arg val "$val" '.[$key1][$key2] = $val' $p4 > $tmp1 && cp $tmp1 $p4
    elif  [[ $(countchar "$key" "_") == 2 ]] ; then
        key1=${key%%_*}
        key3=${key##*_}
        int1=${key%_*}
        key2=${int1#*_}
        jq --arg key1 "$key1" --arg key2 "$key2" --arg key3 "$key3" --arg val "$val" '.[$key1][$key2][$key3] = $val' $p4 > $tmp1 && cp $tmp1 $p4
    else 
        jq --arg key "$key" --arg val "$val" '.[$key] = $val' $p4 > $tmp1 && cp $tmp1 $p4
    fi

done
rm $tmp1
}


