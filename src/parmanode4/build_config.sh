function build_config {

file=$dp/p4.json

#build arrays first

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
       grep -q "\"$name\"" <<< ${INSTALLED[@]} && continue
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
  printf '"partially installed":[' ; printf '%s,' "${P_INSTALLED[@]}" | sed 's/,$//' ; printf '],\n'
  # parmanode.conf key-values
  printf '"parmanode conf":{' ; printf '%s,' "${P_CONF[@]}" | sed 's/,$//' ; printf '},\n'
  # hide_messages.conf 
  printf '"hide messages":{' ; printf '%s,' "${HM_CONF[@]}" | sed 's/,$//' ; printf '}\n'
  printf '}\n'
} > "$file"

} 
