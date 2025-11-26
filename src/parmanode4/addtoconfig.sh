#commad separated list of arguments, key1=val1,key2=val2 etc...

function addToConfig {
echo "$@" > /tmp/addtoconfig

IFS=, read -r -a items <<<"$@"

for item in ${items[@} ; do
    key=${item%=*}
    val=${item#*=}
done


