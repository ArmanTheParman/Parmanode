function chuck {
    if [[ $chuck ==1 ]] ; then
    echo "Debugging for chuck."
    echo "$1"
    enter_continue
    return 0
    fi
}