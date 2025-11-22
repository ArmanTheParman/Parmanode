function build_config {

#build arrays first
tmp=$(mktemp)

  #makes json array list of all installed programs and another of partially installed programs
  if test -f $ic ; then
  declare -a INSTALLED=()
  while IFS=- read -r name type ; do
    [[ $type == "end" ]] || continue
    INSTALLED+=( "$(jq -R <<<"$name")" )
  done < "$ic" ;

  P_INSTALLED=()
  while IFS=- read -r name type ; do
      [[ $type == "start" ]] || continue
       grep -q "\"$name\"" <<< "${INSTALLED[*]}" && continue
      P_INSTALLED+=( "$(jq -R <<<"$name")" )
  done < "$ic" 
  fi

# Make an array of parmanode.conf
  if test -f $pc ; then
  P_CONF=()
  while IFS== read -r LHS RHS ; do
    P_CONF+=( "\"$LHS\": \"$RHS\"" )
  done < "$pc"
  fi 

# Make an array of hide_messages.conf
  if test -f $hm ; then
  HM_CONF=()
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
} > "$p4"

jq '. + { "running": [] }' "$p4" > $tmp && mv $tmp $p4

app_versions build

tmp=$(mktemp)
jq --slurpfile v "$dp/versions.json" '.app_versions = $v[0]' "$p4" > $tmp && mv $tmp $p4

} 
