#commad separated list of arguments, key1=val1,key2=val2 etc...

function addToConfig {
echo "$@" > /tmp/addtoconfig

IFS=, read -r -a items <<<"$@"
tmp1=$(mktemp)
for item in "${items[@]}" ; do
    key=${item%=*}
    val=${item#*=}
    jq --arg key "$key" --arg val "$val" '.[$key] = $val' $p4 > $tmp1 && cp $tmp1 $p4
done
rm $tmp1
}


