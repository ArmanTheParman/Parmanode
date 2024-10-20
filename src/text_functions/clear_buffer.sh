function clear_buffer {
    while read -r -t 0; do read -r; done
}