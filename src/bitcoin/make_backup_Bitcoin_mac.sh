function make_backup_Bitcoin_mac {

prefix="$HOME/Library/Application\ Support/Bitcoin_backup_"
counter=0
final_directory="$prefix$counter"

while [ -d "$final_directory" ]
do
    counter=$((counter + 1))
    final_directory="$prefix$counter"
done

mv $HOME/Library/Application\ Support "${final_directory}" > dev/null 2>&1
set_terminal ; echo "Moved $HOME/Library/Application\ Support/Bitcoin to $final_directory"
enter_continuer
return 0
}