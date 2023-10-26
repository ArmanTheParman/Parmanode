function main_loop_count {

local file="$dp/main_loop_count"

if [[ $1 == new ]] ; then 
  echo "main_loop=0" > $file
  if [[ -z $2 ]] ; then return 0 ; fi
fi

if [[ $1 == add  || $2 == add ]] ; then
soucre $file >/dev/null 2>&1
main_loop=$((main_loop + 1))
export main_loop
fi

if [[ $1 == source ]] ; then
source $file
fi

if [[ $main_loop -gt 100 ]] ; then
announce \
    "The main menu has looped over 100 times. This not a bug, just
    a count of the number of times you've re-loaded the main menu. It 
    will probably be fine, but as a precaution, I suggest you exit
    Parmanode and load it again get the count back to zero."
fi
}
