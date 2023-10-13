function chuck {
    if [[ $chuck == 1 ]] ; then
    echo "Debugging"
    echo "$1"
    enter_continue
    return 0
    fi
}