function make_backup_dot_bitcoin {
                                        # It is not known how many backups there are so a
                                        # loop is needed.
prefix="$HOME/.bitcoin_backup_"
counter=0
final_directory="$prefix$counter"       # The aim is to produce a backup directory named 
                                        #.bitcoin_backup_ followed by an integer.

while [ -d "$final_directory" ]         # counts the number of backups that exist with
                                        # this numbering format.
do
    counter=$((counter + 1))
    final_directory="$prefix$counter"
done

mv $HOME/.bitcoin "${final_directory}" >$dn 2>&1
set_terminal ; echo "Movido $HOME/.bitcoin para $final_directory"
enter_continue
return 0
}
