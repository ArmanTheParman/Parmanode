function build_config {

file=$dp/p4_installed.conf

#build arrays first

  #makes json array list of all installed programs (both program-start and program-end exist if installed).
  declare -g INSTALLED=$(mktemp)
  grep '\-end' $ic | cut -d \- -f1 | while IFS= read -r line ; do
    echo "$line" | jq -R . >> $INSTALLED
  done
  {
    echo -en "["
    paste -s -d, $INSTALLED | tr -d '\n'
    echo -en "]\n"
  } > $INSTALLED

  #makes a json array list of all partially installed programs (program-start exists but not program-end if partially installed)
  declare -g p_installed=$(mktemp)
  grep '\-start' $ic | cut -d \- -f1 | while IFS= read -r line ; do
      if grep -q "\"$line\"" $INSTALLED ; then continue ; fi #exclude if installed fully
      echo "$line" | jq -R . >> $p_installed
  done
  {
    echo -en "["
    paste -s -d, $p_installed | tr -d '\n'
    echo -en "]\n"
  } > $p_installed


  rm $INSTALLED $p_installed
  }