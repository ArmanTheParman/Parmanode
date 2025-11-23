function build_config {

#starts building $p4 (p4.json) fresh every time, so do not try to merge objects to it they will get wiped.
#whats_running and connected_drives called within this function at the end

tmp1=$(mktemp)
tmp2=$(mktemp)
declare -a INSTALLED=()
declare -a P_INSTALLED=()
declare -a P_CONF=()
declare -a HM_CONF=()

  #makes json array list of all installed programs and another of partially installed programs
  if test -f $ic ; then
  while IFS=- read -r name type ; do
    [[ $type == "end" ]] || continue
    INSTALLED+=( "$(jq -R <<<"$name")" )
  done < "$ic" ;

  while IFS=- read -r name type ; do
      [[ $type == "start" ]] || continue
       grep -q "\"$name\"" <<< "${INSTALLED[*]}" && continue
      P_INSTALLED+=( "$(jq -R <<<"$name")" )
  done < "$ic" 
  fi

# Make an array of parmanode.conf
  if test -f $pc ; then
  while IFS== read -r LHS RHS ; do
    P_CONF+=( "\"$LHS\": \"$RHS\"" )
  done < "$pc"
  fi 

# Make an array of hide_messages.conf
  if test -f $hm ; then
  while IFS== read -r LHS RHS ; do
    HM_CONF+=( "\"$LHS\": \"$RHS\"" )
  done < "$hm"
  fi

{
  printf '{\n'
  # installed
  printf '"installed":[' ; printf '%s,' "${INSTALLED[@]}" | sed 's/,$//' ; printf '],\n'
  # partially installed
  printf '"partially_installed":[' ; printf '%s,' "${P_INSTALLED[@]}" | sed 's/,$//' ; printf '],\n'
  # parmanode.conf key-values
  printf '"parmanode.conf":{' ; printf '%s,' "${P_CONF[@]}" | sed 's/,$//' ; printf '},\n'
  # hide_messages.conf 
  printf '"hide_messages":{' ; printf '%s,' "${HM_CONF[@]}" | sed 's/,$//' ; printf '}\n'
  printf '}\n'
} > "$tmp1" && mv $tmp1 $p4

# app versions object
app_versions build #first make versions.json
jq --slurpfile v "$dp/versions.json" '.app_versions = $v[0]' "$p4" > $tmp2 && mv $tmp2 $p4

whats_running
connected_drives
detect_internal_drive

}

function connected_drives {
#adds fresh state of connected drives to $p4
tmp3=$(mktemp)
tmp4=$(mktemp)
# connected drives object
jq 'del(.blockdevices)' $p4 > $tmp3
lsblk --nodeps -p --json -o NAME,SIZE,TYPE,MODEL,MOUNTPOINT,TRAN | jq --argfile tmp $tmp3 '$tmp + .' > $tmp4 && mv $tmp4 $p4
}

function detect_internal_drive {

[[ $OS == "Mac" ]] && return 1 

mapfile -t x < <(lsblk --nodeps -p -n -o name)

for i in ${x[*]} ; do 
  while IFS= read -r j ; do if [[ $j == "/" ]] ; then 
    target=$i
    fi 
  done < <( lsblk -n -o mountpoint $i)
done 

tmp6=$(mktemp)
tmp7=$(mktemp)

jq 'del(.internaldrive)' $p4 > $tmp6

printf "{ \"internaldrive\": \"%s\" }" $target | jq . | jq --argfile tmp $tmp6 '$tmp + .' > $tmp7 && mv $tmp7 $p4 && rm $tmp6 >$dn
}
