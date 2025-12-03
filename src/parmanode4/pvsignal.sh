function pvsignal {
    {
    printf "###ParmaViewSigStart###"
    # delimeter is \0 (null), so new lines are captured in the variable.
    # loop is actually redundant because of this, but leaving it in case I change the delimeter later.
    while IFS= read -r -d '' data ; do 
        printf "%s" "$data"
    done
    printf "###ParmaViewSigEnd###"
    } > $parmanode_unix_socket
}