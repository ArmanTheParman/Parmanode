function source_parmanode {

    if [ -e "$HOME/parman_programs/parmanode/src" ]; then

        for file in "$HOME/parman_programs/parmanode/src"/*/*.sh; do
            [ -f "$file" ] && source "$file"
        done

        return 0
    else
        return 1
    fi
}